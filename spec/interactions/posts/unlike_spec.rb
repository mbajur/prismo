# frozen_string_literal: true

require 'rails_helper'

describe Posts::Unlike do
  let(:post) { create(:post, :link) }
  let(:user) { create(:user) }
  let(:inputs) { { post: post, user: user } }

  let(:outcome) { described_class.run(inputs) }
  let(:outcome!) { described_class.run!(inputs) }
  let(:result) { outcome.result }
  let(:errors) { outcome.errors }

  it { expect(outcome).to be_valid }

  context "when the user has liked the post" do
    let!(:like) { create(:like, likeable: post, fedipub_actor: user.fedipub_actor) }
    let!(:like_activity) { Fedipub::Activity.create!(actor: user.fedipub_actor, action: "Like", entity: post) }

    it "destroys the like" do
      expect { outcome }.to change(Like, :count).by(-1)
    end

    it "returns the destroyed like" do
      expect(result.id).to eq(like.id)
    end

    it "undoes the like activity" do
      expect { outcome }.to change(Fedipub::Activity, :count).by(1)

      undo_activity = Fedipub::Activity.last
      expect(undo_activity.action).to eq("Undo")
      expect(undo_activity.entity).to eq(like_activity)
    end

    it "enqueues a job to update karma" do
      expect(Users::UpdateKarmaJob).to receive(:perform_later).with(post.user, "Post", "remove")
      outcome
    end
  end

  context "when the user has not liked the post" do
    it "does not destroy any like" do
      expect { outcome }.not_to change(Like, :count)
    end

    it "returns nil" do
      expect(result).to be_nil
    end

    it "does not enqueue a job to update karma" do
      expect(Users::UpdateKarmaJob).not_to receive(:perform_later)
      outcome
    end
  end
end
