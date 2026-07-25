class Flag < ApplicationRecord
  belongs_to :actor, polymorphic: true
  belongs_to :flaggable, polymorphic: true

  scope :unresolved, ->{ where(action_taken: false) }
end
