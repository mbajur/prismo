# frozen_string_literal: true

require 'rails_helper'

describe Fedipub::IncomingFediverseDataHandlerJob do
  subject(:perform) { described_class.perform_now(incoming_activity) }

  let(:incoming_activity) { create(:fedipub_incoming_activity, entity_class: "Post", data: data) }
  let(:activity_id) { "https://example.com/activities/1" }
  let(:data) { { "id" => activity_id } }

  before do
    allow(Post).to receive(:handle_incoming_fediverse_data)
  end

  it "marks the incoming activity as processing" do
    expect(incoming_activity).to receive(:processing!).and_call_original
    perform
  end

  it "constantizes the entity class and delegates handling to it" do
    perform

    expect(Post).to have_received(:handle_incoming_fediverse_data).with(activity_id)
  end

  context "when the stored data is a full activity hash" do
    let(:data) { { "id" => activity_id, "type" => "Create" } }

    it "delegates handling with the hash as-is" do
      perform

      expect(Post).to have_received(:handle_incoming_fediverse_data).with(data)
    end
  end

  it "marks the incoming activity as processed" do
    perform

    expect(incoming_activity.reload).to be_processed
  end

  context "when handling raises an error" do
    before do
      allow(Post).to receive(:handle_incoming_fediverse_data).and_raise(StandardError)
    end

    it "marks the incoming activity as failed" do
      expect { perform }.to raise_error(StandardError)

      expect(incoming_activity.reload).to be_failed
    end

    it "re-raises the error" do
      expect { perform }.to raise_error(StandardError)
    end
  end
end
