module Fedipub
  class ActorDecorator < Draper::Decorator
    delegate_all

    def to_s
      object.short_at_address
    end

    def path
      if object.local?
        h.user_path(object.username)
      else
        object.federated_url
      end
    end

    def avatar_url
      if object.local?
        object.entity.avatar_url
      else
        object.extensions.dig("icon", "url")
      end
    end
  end
end
