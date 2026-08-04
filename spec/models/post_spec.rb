# frozen_string_literal: true

require 'rails_helper'

describe Post, type: :model do
  subject { build(:post, user: user) }
  let(:user) { create(:user) }

  it { is_expected.to have_many(:comments) }
  it { is_expected.to belong_to(:url_meta).optional }
  it { is_expected.to belong_to(:group) }
end
