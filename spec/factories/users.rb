# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username(separators: %w[_]) }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 8) }
    confirmed_at { Time.current }
  end
end
