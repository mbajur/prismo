# frozen_string_literal: true

require 'rails_helper'

describe Comments::IncomingFediverseDataHandler do
  subject(:handle) { described_class.new(activity_hash_or_id).call }

  let(:activity_hash_or_id) do
    {
      "id" => "https://remote.example/activities/1",
      "type" => activity_type,
      "object" => object_hash
    }
  end
  let(:object_hash) { { "id" => "https://remote.example/objects/1", "type" => "Note" } }
  let(:activity_type) { "Create" }
  let(:entity) { create(:comment) }

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
    let(:transformed_attributes) { { body: "Updated body" } }

    before do
      allow(Comment).to receive(:from_activitypub_object).with(object_hash).and_return(transformed_attributes)
    end

    it "assigns the attributes transformed from the object onto the entity" do
      handle

      expect(entity.body).to eq("Updated body")
    end

    it "persists the entity without touching timestamps" do
      expect(entity).to receive(:save!).with(touch: false)
      handle
    end

    it "returns the updated entity" do
      expect(handle).to eq(entity)
    end
  end

  context "when object contains tags" do
    let(:object_hash) do
      {
        "tag" => [
          {
            "type" => "Mention",
            "href" => "https://example.com/federation/actors/foo"
          },
          {
            "type" => "Mention",
            "href" => "https://example.com/federation/actors/bar"
          }
        ]
      }
    end

    before do
      foo_webfinger_data = {
        "links" => [
          {
            "rel" => "self",
            "type" => "application/ld+json; profile=\"https://www.w3.org/ns/activitystreams\"",
            "href" => "https://example.com/federation/actors/foo" }
        ]
      }
      foo_actor_data = {
        "id" => "https://example.com/federation/actors/foo",
        "type" => "Person",
        "name" => "foo",
        "preferredUsername" => "foo",
        "inbox" => "https://example.com/federation/actors/foo/inbox",
        "outbox" => "https://example.com/federation/actors/foo/outbox"
      }
      stub_request(:get, "http://example.com/.well-known/webfinger?resource=acct:foo@example.com")
        .to_return(status: 200, body: foo_webfinger_data.to_json, headers: { 'Content-Type' => 'application/json' })
      stub_request(:get, "https://example.com/federation/actors/foo")
        .to_return(status: 200, body: foo_actor_data.to_json, headers: { 'Content-Type' => 'application/json' })

      bar_webfinger_data = {
        "links" => [
          {
            "rel" => "self",
            "type" => "application/ld+json; profile=\"https://www.w3.org/ns/activitystreams\"",
            "href" => "https://example.com/federation/actors/bar" }
        ]
      }
      bar_actor_data = {
        "id" => "https://example.com/federation/actors/bar",
        "type" => "Person",
        "name" => "bar",
        "preferredUsername" => "bar",
        "inbox" => "https://example.com/federation/actors/bar/inbox",
        "outbox" => "https://example.com/federation/actors/bar/outbox"
      }
      stub_request(:get, "http://example.com/.well-known/webfinger?resource=acct:bar@example.com")
        .to_return(status: 200, body: bar_webfinger_data.to_json, headers: { 'Content-Type' => 'application/json' })
        stub_request(:get, "https://example.com/federation/actors/bar")
        .to_return(status: 200, body: bar_actor_data.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    context "when there are more mentions than already assigned to entity" do
      let!(:foo_actor) { create(:fedipub_actor, :distant, username: "foo", server: "example.com") }

      before do
        create(:fedipub_mention, actor: foo_actor, entity: entity)
      end

      it "creates new mention entities for the additional mentions" do
        expect { subject }.to change { entity.fedipub_mentions.count }.from(1).to(2)
        expect(entity.mentioned_fedipub_actors.map(&:username)).to eq([ "foo", "bar" ])
      end
    end

    context "when there are less mentions than already assigned to entity" do
      let!(:baz_actor) { create(:fedipub_actor, :distant, username: "baz", server: "example.com") }

      before do
        create(:fedipub_mention, actor: baz_actor, entity: entity)
      end

      it "discards existing mention entities" do
        expect { subject }.to change { entity.fedipub_mentions.count }.from(1).to(2)
        expect(entity.mentioned_fedipub_actors.map(&:username)).to eq([ "foo", "bar" ])
      end
    end
  end
end
