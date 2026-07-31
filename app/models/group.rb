class Group < ApplicationRecord
  include Fedipub::ActorEntity

  Group.acts_as_fedipub_actor username_field: :slug,
                              name_field: :name,
                              actor_type: "Group"
end
