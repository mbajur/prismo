class Fedipub::Mention < ApplicationRecord
  belongs_to :entity, polymorphic: true
  belongs_to :actor
end
