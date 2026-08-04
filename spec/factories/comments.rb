# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :comment do
    body { Faker::Markdown.sandwich }

    user
    post
  end
end
