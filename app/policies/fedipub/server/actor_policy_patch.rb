module Fedipub
  module Server
    module ActorPolicyPatch
      def moderators?
        record.entity_type == "Group"
      end
    end
  end
end

Fedipub::Server::ActorPolicy.prepend(Fedipub::Server::ActorPolicyPatch)
