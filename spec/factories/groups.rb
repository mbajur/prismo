# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :group do
    name { Faker::Company.unique.name }
    slug { Faker::Internet.unique.slug }
  end
end
