# frozen_string_literal: true

require 'rails_helper'

describe ActivityPub::UndoLikeActivityHandler do
  describe '.handle_undo_like_request' do
    let!(:actor) { create(:actor, :distant) }
    let!(:entity) { create(:post) }

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
        'id'     => 'https://example.com/activities/2',
        'type'   => 'Undo',
        'actor'  => actor.federated_url,
        'object' => {
          'id'     => 'https://example.com/activities/1',
          'type'   => 'Like',
          'actor'  => actor.federated_url,
          'object' => {
            'id'   => entity.federated_url,
            'type' => 'Article'
          }
        }
      }
    end

    subject(:handle_undo_like_request) { described_class.handle_undo_like_request(activity_hash) }

    context 'when the actor has liked the entity locally' do
      let!(:like) { create(:like, likeable: entity, fedipub_actor: actor) }
      let!(:like_activity) { Fedipub::Activity.create!(actor: actor, action: 'Like', entity: entity) }

      before { entity.update!(likes_count: 99) }

      it 'destroys the like' do
        expect { handle_undo_like_request }.to change(Like, :count).by(-1)
      end

      it 'recalculates the entity likes count' do
        expect { handle_undo_like_request }.to change { entity.reload.likes_count }.to(0)
      end

      it 'creates an undo activity for the original like activity' do
        expect { handle_undo_like_request }.to change { Fedipub::Activity.where(action: 'Undo').count }.by(1)

        undo_activity = Fedipub::Activity.where(action: 'Undo').last
        expect(undo_activity.entity).to eq(like_activity)
      end
    end

    context 'when a like activity exists without a local like record' do
      let!(:like_activity) { Fedipub::Activity.create!(actor: actor, action: 'Like', entity: entity) }

      it 'still undoes the like activity' do
        expect { handle_undo_like_request }.to change { Fedipub::Activity.where(action: 'Undo').count }.by(1)

        undo_activity = Fedipub::Activity.where(action: 'Undo').last
        expect(undo_activity.entity).to eq(like_activity)
      end
    end

    context 'when the actor has not liked the entity at all' do
      it 'does not destroy any like' do
        expect { handle_undo_like_request }.not_to change(Like, :count)
      end

      it 'does not create an undo activity' do
        expect { handle_undo_like_request }.not_to change { Fedipub::Activity.where(action: 'Undo').count }
      end
    end

    context 'when the undone object type is not handled by any entity' do
      let(:activity_hash) do
        {
          'id'     => 'https://example.com/activities/2',
          'type'   => 'Undo',
          'actor'  => actor.federated_url,
          'object' => {
            'id'     => 'https://example.com/activities/1',
            'type'   => 'Like',
            'actor'  => actor.federated_url,
            'object' => { 'id' => 'https://example.com/videos/1', 'type' => 'Video' }
          }
        }
      end

      it 'raises because the entity cannot be resolved' do
        expect { handle_undo_like_request }.to raise_error(NoMethodError, /persisted\?/)
      end
    end
  end
end
