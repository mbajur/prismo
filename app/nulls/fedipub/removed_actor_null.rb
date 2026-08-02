module Fedipub
  class RemovedActorNull
    def initialize(parent_entity)
      @parent_entity = parent_entity
    end

    def entity
      User.new
    end

    def decorate
      Fedipub::ActorDecorator.new(self)
    end

    def local?
      @parent_entity.local_fedipub_entity?
    end

    def extensions
      {}
    end

    def federated_url
      ""
    end

    def short_at_address
      "Ghost"
    end
  end
end
