# frozen_string_literal: true

require 'rails_helper'

describe Comment, type: :model do
  describe ".handle_incoming_fediverse_data_async" do
    subject(:handle_async) { described_class.handle_incoming_fediverse_data_async(activity_hash_or_id) }

    shared_examples "enqueues the job" do
      it "enqueues the incoming fediverse data handler job with the incoming activity" do
        expect(Fedipub::IncomingFediverseDataHandlerJob).to receive(:perform_later) do |incoming_activity|
          expect(incoming_activity).to eq(Fedipub::IncomingActivity.last)
        end

        handle_async
      end
    end

    context "when given a bare URL/id" do
      let(:activity_hash_or_id) { "https://remote.example/activities/1" }

      include_examples "enqueues the job"

      it "creates an incoming activity wrapping the id in a hash" do
        expect { handle_async }.to change(Fedipub::IncomingActivity, :count).by(1)

        incoming_activity = Fedipub::IncomingActivity.last
        expect(incoming_activity.entity_class).to eq("Comment")
        expect(incoming_activity.data).to eq({ "id" => activity_hash_or_id })
      end
    end

    context "when given an activity hash" do
      let(:activity_hash_or_id) { { "id" => "https://remote.example/activities/1", "type" => "Create" } }

      include_examples "enqueues the job"

      it "creates an incoming activity with the hash as-is" do
        expect { handle_async }.to change(Fedipub::IncomingActivity, :count).by(1)

        incoming_activity = Fedipub::IncomingActivity.last
        expect(incoming_activity.entity_class).to eq("Comment")
        expect(incoming_activity.data).to eq(activity_hash_or_id)
      end
    end
  end

  describe ".handle_incoming_fediverse_data" do
    subject(:handle) { described_class.handle_incoming_fediverse_data(activity_hash_or_id) }

    let(:activity_hash_or_id) { "https://remote.example/activities/1" }
    let(:handler) { instance_double(Comments::IncomingFediverseDataHandler, call: create(:comment)) }

    before do
      allow(Comments::IncomingFediverseDataHandler).to receive(:new).with(activity_hash_or_id).and_return(handler)
    end

    it "delegates to Comments::IncomingFediverseDataHandler" do
      handle

      expect(handler).to have_received(:call)
    end

    it "does not raise an error" do
      expect { handle }.not_to raise_error
    end
  end
end
