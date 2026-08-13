class Fedipub::IncomingActivity < ApplicationRecord
  enum :status, [ :pending, :processed, :failed ], default: :pending

  validates :data, presence: true
  validates :entity_class, presence: true
end
