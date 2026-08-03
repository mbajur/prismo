require "fediverse/inbox"

module Prismo
  module FedipubArrayHandlesPatch
    def data_entity_handlers_for(type)
      Fedipub::Configuration.data_types.select do |_, configuration|
        Array(configuration[:handles]).include?(type)
      end.map(&:last)
    end
  end

  module FediverseInboxArrayHandlesPatch
    def register_handler(activity_type, object_type, klass, method)
      Array(object_type).each do |single_object_type|
        super(activity_type, single_object_type, klass, method)
      end
    end
  end
end

Fedipub.singleton_class.prepend(Prismo::FedipubArrayHandlesPatch)
Fediverse::Inbox.singleton_class.prepend(Prismo::FediverseInboxArrayHandlesPatch)
