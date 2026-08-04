# frozen_string_literal: true

require 'rails_helper'

describe Users::UpdateKarmaJob do
  let(:user) { create(:user) }

  describe '#perform' do
    subject do
      described_class.perform_now(user, resource_type, add_or_remove)
    end

    context 'when we want to increment posts karma' do
      let(:resource_type) { 'Post' }
      let(:add_or_remove) { 'add' }

      it 'increments account posts_karma' do
        expect { subject }.to change { user.reload.posts_karma }.by(1)
      end
    end

    context 'when we want to increment comments karma' do
      let(:resource_type) { 'Comment' }
      let(:add_or_remove) { 'add' }

      it 'increments account comments_karma' do
        expect { subject }.to change { user.reload.comments_karma }.by(1)
      end
    end

    context 'when we want to decrement posts karma' do
      let(:resource_type) { 'Post' }
      let(:add_or_remove) { 'remove' }

      it 'decrements account posts_karma' do
        expect { subject }.to change { user.reload.posts_karma }.by(-1)
      end
    end

    context 'when we want to increment comments karma' do
      let(:resource_type) { 'Comment' }
      let(:add_or_remove) { 'remove' }

      it 'decrements account comments_karma' do
        expect { subject }.to change { user.reload.comments_karma }.by(-1)
      end
    end
  end
end
