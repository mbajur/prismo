# frozen_string_literal: true

require 'rails_helper'

describe Posts::Create do
  let(:inputs) { valid_inputs }
  let(:user) { create(:user) }
  let!(:group) { create(:group, supergroup: true) }
  let(:valid_inputs) do
    {
      url: 'http://example.com',
      title: 'Sample story',
      tag_list: 'foo, bar',
      description: 'Sample description',
      user: user
    }
  end

  let(:outcome) { described_class.run(inputs) }
  let(:outcome!) { described_class.run!(inputs) }
  let(:result) { outcome.result }
  let(:errors) { outcome.errors }

  before do
    allow(Posts::ScrapJob).to receive(:perform_later)
  end

  context 'when inputs are valid' do
    let(:inputs) { valid_inputs }
    it { expect(outcome).to be_valid }
  end

  context 'when url and description are blank' do
    let(:inputs) do
      valid_inputs.merge(
        url: nil,
        description: nil
      )
    end

    it { expect(outcome).to be_invalid }
  end

  context 'when there are less tags than set in settings' do
    let(:inputs) do
      valid_inputs.merge(
        tag_names: [ 'foo' ]
      )
    end

    before { Setting.min_post_tags = 10 }
    after { Setting.min_post_tags = 0 }

    it { expect(outcome).to be_invalid }
  end

  context 'when min_post_tags setting is set to 0' do
    let(:inputs) do
      valid_inputs.merge(
        tag_names: []
      )
    end

    around do |example|
      original_value = Setting.min_post_tags
      Setting.min_post_tags = 0
      example.run
      Setting.min_post_tags = original_value
    end

    it 'does not validate tags count' do
      expect(outcome).to be_valid
    end
  end

  context 'when URL is invalid' do
    let(:inputs) do
      valid_inputs.merge(
        url: 'wrongurl.com/xxx'
      )
    end

    it { expect(outcome).to be_invalid }
  end

  describe 'setting domain' do
    let(:inputs) do
      valid_inputs.merge(
        url: 'https://prismo.zip/post/123'
      )
    end

    it 'sets domain if url is present' do
      expect(result.url_domain).to eq 'prismo.zip'
    end
  end

  describe 'hooks' do
    context 'when created' do
      it "touches user last_active_at" do
        expect { outcome! }.to change { user.reload.last_active_at }
      end

      it "caches the description" do
        expect_any_instance_of(Post).to receive(:cache_description)
        outcome!
      end

      it 'enqueues Posts::ScrapJob' do
        expect(Posts::ScrapJob).to receive(:perform_later)
        outcome!
      end

      context 'when post is local, link and webmentions are enabled' do
        let(:inputs) do
          valid_inputs.merge(
            url: 'https://prismo.zip/posts/123'
          )
        end

        it 'schedules webmention job' do
          expect(Posts::SendWebmentionJob).to receive(:perform_later)
          outcome!
        end
      end

      context 'when post is local, text and webmentions are enabled' do
        let(:inputs) do
          valid_inputs.merge(
            description: 'Post description',
            url: nil
          )
        end

        it 'schedules webmention job' do
          expect(Posts::SendWebmentionJob).to_not receive(:perform_later)
          outcome!
        end
      end
    end
  end

  describe 'assigning to supergroup' do
    it 'assigns story to supergroup' do
      outcome!
      expect(result.group).to eq group
    end
  end
end
