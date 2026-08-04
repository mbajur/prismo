# frozen_string_literal: true

require 'rails_helper'

describe Posts::Update do
  let(:user) { create(:user) }
  let(:post) { create(:post, :link, user: user) }

  let(:args) do
    {
      user: user,
      title: 'Sample title',
      tag_list: 'foo, bar',
      post: post,
      url: post.url,
      description: post.description
    }
  end

  describe '#run' do
    subject { described_class.run(args) }

    context 'when params are fully valid' do
      it { is_expected.to be_valid }

      it 'updates modified_at column' do
        expect { subject }.to change(post, :modified_at)
      end

      context 'when edit grace period has passed' do
        before do
          post.update(created_at: Time.current - 4.minutes)
        end

        it 'updates modified_count column' do
          expect { subject }.to change(post, :modified_count).by(1)
        end
      end

      context 'when edit grace period has not passed' do
        before do
          post.update(created_at: Time.current - 2.minutes)
        end

        it 'updates modified_count column' do
          expect { subject }.to_not change(post, :modified_count)
        end
      end
    end

    context 'when actor is admin' do
      let(:user) { create(:user, :admin) }

      it 'is possible to update post url' do
        args[:url] = 'https://changed.com'
        expect { subject }.to change(post, :url).to 'https://changed.com'
      end

      it 'is possible to update title even when title update limit is exceed' do
        args[:title] = 'Changed title'
        expect { subject }.to change(post, :title).to 'Changed title'
      end
    end

    context 'when actor is a regular user' do
      it 'is not possible to update post url' do
        args[:url] = 'https://changed.com'
        expect { subject }.to_not change(post, :url)
      end

      it 'is not possible to update title when title update limit is exceed' do
        post.update(created_at: 65.minutes.ago)
        args[:title] = 'Changed title'

        expect(subject).to_not be_valid
      end
    end
  end
end
