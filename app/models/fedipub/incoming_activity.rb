class Fedipub::IncomingActivity < ApplicationRecord
  attribute :data, :json

  enum :status, {
    pending: "pending",
    processing: "processing",
    processed: "processed",
    failed: "failed"
  }, default: :pending

  validates :data, presence: true
  validates :entity_class, presence: true
end
