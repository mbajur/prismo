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
end
