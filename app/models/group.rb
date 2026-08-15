class Group < ApplicationRecord
  include Fedipub::ActorEntity

  Group.acts_as_fedipub_actor username_field: :slug,
                              name_field: :name,
                              actor_type: "Group"

  def to_activitypub_object
    {
      summary: Setting.site_description,
      source: {
        content: Setting.site_description,
        type: "text/markdown"
      },
      "attributedTo" => Fedipub::Engine.routes.url_helpers.moderators_server_actor_url(fedipub_actor)
    }
  end
end
