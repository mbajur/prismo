# frozen_string_literal: true

require 'rails_helper'

describe Fedipub::IncomingFediverseDataHandlerJob do
  subject(:perform) { described_class.perform_now(incoming_activity) }

  let(:incoming_activity) { create(:fedipub_incoming_activity, entity_class: "Post", data: activity_id) }
  let(:activity_id) { "https://example.com/activities/1" }

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

  it "marks the incoming activity as processed" do
    perform

    expect(incoming_activity.reload).to be_processed
  end

  context "when handling raises an error" do
    before do
      allow(Post).to receive(:handle_incoming_fediverse_data).and_raise(StandardError)
    end

    it "marks the incoming activity as failed" do
      perform

      expect(incoming_activity.reload).to be_failed
    end

    it "does not raise" do
      expect { perform }.not_to raise_error
    end
  end
end
