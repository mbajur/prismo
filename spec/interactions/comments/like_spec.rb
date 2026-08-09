# frozen_string_literal: true

require 'rails_helper'

describe Comments::Like do
  let(:comment) { create(:comment) }
  let(:user) { create(:user) }
  let(:inputs) { { comment: comment, user: user } }

  let(:outcome) { described_class.run(inputs) }
  let(:outcome!) { described_class.run!(inputs) }
  let(:result) { outcome.result }
  let(:errors) { outcome.errors }

  it { expect(outcome).to be_valid }

  it "updates user last_active_at" do
    expect { outcome }.to change { user.reload.last_active_at }
  end

  it "creates a like" do
    expect(comment).to receive(:like!).with(actor: user.fedipub_actor)
    outcome
  end

  it "caches likes" do
    expect(comment).to receive(:cache_likes)
    outcome
  end

  it "enqueues a job to update karma" do
    expect(Users::UpdateKarmaJob).to receive(:perform_later).with(comment.user, "Comment")
    outcome
  end

  context "when a like already exists for the user's actor" do
    before { create(:like, likeable: comment, fedipub_actor: user.fedipub_actor) }

    it "does not create a duplicate like" do
      expect { outcome }.not_to change(Like, :count)
    end

    it "does not like the comment again" do
      expect(comment).not_to receive(:like!)
      outcome
    end

    it "does not cache likes again" do
      expect(comment).not_to receive(:cache_likes)
      outcome
    end

    it "does not enqueue a job to update karma again" do
      expect(Users::UpdateKarmaJob).not_to receive(:perform_later)
      outcome
    end
  end
end
