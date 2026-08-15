# frozen_string_literal: true

FactoryBot.define do
  factory :like do
    likeable factory: :post
    fedipub_actor
  end
end
