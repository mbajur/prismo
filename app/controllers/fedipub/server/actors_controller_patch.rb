module Fedipub
  module Server
    module ActorsControllerPatch
      def moderators
        set_actor
        @actors = Fedipub::Actor.where(entity: User.admins)

        render_collection(
          collection: @actors.page(params[:page]),
          actor:      @actor,
          url_helper: :moderators_server_actor_url
        ) do |builder, items|
          builder.array! items.map(&:federated_url)
        end
      end
    end
  end
end

Fedipub::Server::ActorsController.prepend(Fedipub::Server::ActorsControllerPatch)
