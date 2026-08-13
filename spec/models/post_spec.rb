# frozen_string_literal: true

require 'rails_helper'

describe Post, type: :model do
  subject { build(:post, user: user) }
  let(:user) { create(:user) }

  it { is_expected.to have_many(:comments) }
  it { is_expected.to belong_to(:url_meta).optional }
  it { is_expected.to belong_to(:group) }

  describe ".handle_incoming_fediverse_data_async" do
    subject(:handle_async) { described_class.handle_incoming_fediverse_data_async(activity_hash_or_id) }

    let(:activity_hash_or_id) { "https://remote.example/activities/1" }

    it "creates an incoming activity for the entity class" do
      expect { handle_async }.to change(Fedipub::IncomingActivity, :count).by(1)

      incoming_activity = Fedipub::IncomingActivity.last
      expect(incoming_activity.entity_class).to eq("Post")
      expect(incoming_activity.data).to eq(activity_hash_or_id)
    end

    it "enqueues the incoming fediverse data handler job with the incoming activity" do
      expect(Fedipub::IncomingFediverseDataHandlerJob).to receive(:perform_later) do |incoming_activity|
        expect(incoming_activity).to eq(Fedipub::IncomingActivity.last)
      end

      handle_async
    end
  end

  describe ".handle_incoming_fediverse_data" do
    subject(:handle) { described_class.handle_incoming_fediverse_data(activity_hash_or_id) }

    let(:activity_hash_or_id) do
      {
        "id" => "https://remote.example/activities/1",
        "type" => activity_type,
        "object" => object_hash
      }
    end
    let(:object_hash) { { "id" => "https://remote.example/objects/1", "type" => "Page" } }
    let(:activity_type) { "Create" }
    let(:entity) { create(:post, :link) }

    before do
      allow(Fediverse::Request).to receive(:dereference).with(activity_hash_or_id).and_return(activity_hash_or_id)
      allow(Fediverse::Request).to receive(:dereference).with(object_hash).and_return(object_hash)
      allow(Fedipub::Utils::Object).to receive(:find_or_create!).with(object_hash).and_return(entity)
    end

    it "dereferences the activity and its nested object" do
      handle

      expect(Fediverse::Request).to have_received(:dereference).with(activity_hash_or_id)
      expect(Fediverse::Request).to have_received(:dereference).with(object_hash)
    end

    it "finds or creates the entity from the dereferenced object" do
      handle

      expect(Fedipub::Utils::Object).to have_received(:find_or_create!).with(object_hash)
    end

    it "returns the entity" do
      expect(handle).to eq(entity)
    end

    context "when the activity type is Create" do
      let(:activity_type) { "Create" }

      it "does not update the entity's attributes" do
        expect(entity).not_to receive(:assign_attributes)
        handle
      end

      it "does not persist the entity again" do
        expect(entity).not_to receive(:save!)
        handle
      end
    end

    context "when the activity type is Update" do
      let(:activity_type) { "Update" }
      let(:transformed_attributes) { { title: "Updated title" } }

      before do
        allow(described_class).to receive(:from_activitypub_object).with(object_hash).and_return(transformed_attributes)
      end

      it "assigns the attributes transformed from the object onto the entity" do
        handle

        expect(entity.title).to eq("Updated title")
      end

      it "persists the entity without touching timestamps" do
        expect(entity).to receive(:save!).with(touch: false)
        handle
      end

      it "returns the updated entity" do
        expect(handle).to eq(entity)
      end
    end
  end
end
