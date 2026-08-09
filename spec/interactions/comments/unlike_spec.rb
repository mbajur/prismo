# frozen_string_literal: true

require 'rails_helper'

describe Comments::Unlike do
  let(:comment) { create(:comment) }
  let(:user) { create(:user) }
  let(:inputs) { { comment: comment, user: user } }

  let(:outcome) { described_class.run(inputs) }
  let(:outcome!) { described_class.run!(inputs) }
  let(:result) { outcome.result }
  let(:errors) { outcome.errors }

  context "when the user has liked the comment" do
    let!(:like) { create(:like, likeable: comment, fedipub_actor: user.fedipub_actor) }
    let!(:like_activity) { Fedipub::Activity.create!(actor: user.fedipub_actor, action: "Like", entity: comment) }

    it { expect(outcome).to be_valid }

    it "destroys the like" do
      expect { outcome }.to change(Like, :count).by(-1)
    end

    it "undoes the like activity" do
      expect { outcome }.to change(Fedipub::Activity, :count).by(1)

      undo_activity = Fedipub::Activity.last
      expect(undo_activity.action).to eq("Undo")
      expect(undo_activity.entity).to eq(like_activity)
    end

    it "enqueues a job to update karma" do
      expect(Users::UpdateKarmaJob).to receive(:perform_later).with(comment.user, "Comment", "remove")
      outcome
    end
  end

  context "when the user has not liked the comment" do
    it "raises a not found error" do
      expect { outcome }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
