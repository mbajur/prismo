# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :post do
    # account
    tag_names { %w[foo bar] }
    # local { true }
    # uuid { SecureRandom.uuid }

    user
    group

    trait :link do
      sequence(:url) { Faker::Internet.url }
      sequence(:title) { Faker::Company.catch_phrase }
    end

    trait :text do
      url { nil }
      sequence(:description) { Faker::Markdown.sandwich }
    end

    # trait :not_local do
    #   local false
    #   uri Faker::Internet.device_token
    # end

    trait :removed do
      discarded_at { Time.current }
    end
  end
end
