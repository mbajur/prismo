# frozen_string_literal: true

require 'rails_helper'

describe Fedipub::IncomingActivityHandlerJob do
  subject(:perform) { described_class.perform_now(entity_class: entity_class, activity_hash_or_id: activity_hash_or_id) }

  let(:entity_class) { "Post" }
  let(:activity_hash_or_id) { { "id" => "https://example.com/activities/1" } }

  it "constantizes the entity class and delegates handling to it" do
    expect(Post).to receive(:handle_incoming_fediverse_data).with(activity_hash_or_id)
    perform
  end

  context "when entity_class does not resolve to a constant" do
    let(:entity_class) { "NotARealClass" }

    it "raises a NameError" do
      expect { perform }.to raise_error(NameError)
    end
  end
end
