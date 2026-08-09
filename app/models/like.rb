class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true, counter_cache: true
  belongs_to :fedipub_actor, class_name: "Fedipub::Actor"
end
