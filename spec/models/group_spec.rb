# frozen_string_literal: true

require 'rails_helper'

describe Group, type: :model do
  describe "#to_activitypub_object" do
    subject(:activitypub_object) { group.to_activitypub_object }

    let(:group) { create(:group) }

    before do
      @original_site_description = Setting.site_description
      Setting.site_description = "A friendly place to hang out"
    end

    after do
      Setting.site_description = @original_site_description
    end

    it "uses the site description as the summary" do
      expect(activitypub_object[:summary]).to eq("A friendly place to hang out")
    end

    it "includes the site description as markdown source" do
      expect(activitypub_object[:source]).to eq(
        content: "A friendly place to hang out",
        type: "text/markdown"
      )
    end

    it "sets attributedTo to the moderators collection URL for the group's actor" do
      expect(activitypub_object["attributedTo"]).to eq(
        Fedipub::Engine.routes.url_helpers.moderators_server_actor_url(group.fedipub_actor)
      )
    end
  end
end
