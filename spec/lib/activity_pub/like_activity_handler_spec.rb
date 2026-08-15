# frozen_string_literal: true

require 'rails_helper'

describe ActivityPub::LikeActivityHandler do
  describe '.handle_like_activity' do
    let(:actor) { create(:fedipub_actor, :distant) }
    let(:entity) { create(:post) }

    around do |example|
      original_host = Fedipub.configuration.site_host
      original_port = Fedipub.configuration.site_port

      Fedipub.configuration.site_host = 'https://prismo.test'
      Fedipub.configuration.site_port = nil

      example.run

      Fedipub.configuration.site_host = original_host
      Fedipub.configuration.site_port = original_port
    end

    let(:activity_hash) do
      {
        'id'     => 'https://example.com/activities/1',
        'type'   => 'Like',
        'actor'  => actor.federated_url,
        'object' => {
          'id'   => entity.federated_url,
          'type' => 'Article'
        }
      }
    end

    subject(:handle_like_activity) { described_class.handle_like_activity(activity_hash) }

    it 'creates a like' do
      expect { handle_like_activity }.to change(Like, :count).by(1)
    end

    it 'increases the entity likes count' do
      expect { handle_like_activity }.to change { entity.reload.likes_count }.by(1)
    end

    context 'when the liked object type is not handled by any entity' do
      let(:activity_hash) do
        {
          'id'     => 'https://example.com/activities/1',
          'type'   => 'Like',
          'actor'  => actor.federated_url,
          'object' => { 'id' => 'https://example.com/videos/1', 'type' => 'Video' }
        }
      end

      it 'raises a not found error' do
        expect { handle_like_activity }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when a like already exists for the actor' do
      before { create(:like, likeable: entity, fedipub_actor: actor) }

      it 'does not create a duplicate like' do
        expect { handle_like_activity }.not_to change(Like, :count)
      end

      it 'does not increase the entity likes count again' do
        expect { handle_like_activity }.not_to change { entity.reload.likes_count }
      end
    end
  end
end
