# frozen_string_literal: true

require 'rails_helper'

describe Posts::Like do
  let(:post) { create(:post, :link) }
  let(:user) { create(:user) }
  let(:inputs) { { post: post, user: user } }

  let(:outcome) { described_class.run(inputs) }
  let(:outcome!) { described_class.run!(inputs) }
  let(:result) { outcome.result }
  let(:errors) { outcome.errors }

  it { expect(outcome).to be_valid }

  it "updates user last_active_at" do
    expect { outcome }.to change { user.reload.last_active_at }
  end

  it "creates a like" do
    expect(post).to receive(:like!).with(actor: user.fedipub_actor)
    outcome
  end

  it "caches likes" do
    expect(post).to receive(:cache_likes)
    outcome
  end

  it "enqueues a job to update karma" do
    expect(Users::UpdateKarmaJob).to receive(:perform_later).with(post.user, "Post")
    outcome
  end

  context "when a like already exists for the user's actor" do
    before { create(:like, likeable: post, fedipub_actor: user.fedipub_actor) }

    it "does not create a duplicate like" do
      expect { outcome }.not_to change(Like, :count)
    end

    it "does not like the post again" do
      expect(post).not_to receive(:like!)
      outcome
    end

    it "does not cache likes again" do
      expect(post).not_to receive(:cache_likes)
      outcome
    end

    it "does not enqueue a job to update karma again" do
      expect(Users::UpdateKarmaJob).not_to receive(:perform_later)
      outcome
    end
  end
end
