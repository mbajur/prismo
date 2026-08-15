require 'rails_helper'

RSpec.describe '/federation/actors', type: :request do
  describe 'GET /moderators' do
    let(:group) { create(:group) }
    let(:actor) { group.fedipub_actor }

    let!(:admins) { create_list(:user, 2, :admin) }

    before do
      create(:user) # non-admin, should not show up in the collection
    end

    it 'renders a successful response' do
      get fedipub.moderators_server_actor_url(actor), headers: { accept: Mime[:activitypub] }
      expect(response).to be_successful
    end

    it 'reports the total number of admins in the collection' do
      get fedipub.moderators_server_actor_url(actor), headers: { accept: Mime[:activitypub] }
      json = response.parsed_body

      expect(json['totalItems']).to eq(2)
    end

    it 'includes only admin users as ordered items on the collection page' do
      get fedipub.moderators_server_actor_url(actor, page: 1), headers: { accept: Mime[:activitypub] }
      json = response.parsed_body

      expect(json['orderedItems']).to match_array(admins.map { |user| user.fedipub_actor.federated_url })
    end

    ACTIVITYPUB_CONTENT_TYPES.each do |accept|
      it "responds with LD in response to a #{accept} request" do
        get fedipub.moderators_server_actor_url(actor), headers: { accept: accept }
        expect(response.content_type).to eq 'application/ld+json; profile="https://www.w3.org/ns/activitystreams"; charset=utf-8'
      end
    end

    context 'when the actor does not belong to a Group' do
      let(:actor) { create(:user).fedipub_actor }

      it 'raises an authorization error' do
        expect do
          get fedipub.moderators_server_actor_url(actor), headers: { accept: Mime[:activitypub] }
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
