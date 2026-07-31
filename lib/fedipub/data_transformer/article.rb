require "fedipub/utils/context"

module Fedipub
  module DataTransformer
    module Article
      # Renders an Article. The entity is used to determine actor and generic fields data
      #
      # @param entity [#fedipub_actor, #federated_url, #created_at, #updated_at] A model instance
      # @param content [String] Note content
      # @param name [String, nil] Optional name/title
      # @param custom [Hash] Optional additional keys (e.g.: attachment, icon, ...). Defaults will override these.
      #
      # @return [Hash]
      #
      # @example
      #   Fedipub::DataTransformer::Article.to_federation(comment, content: comment.content, custom: { 'inReplyTo' => comment.parent.federated_url })
      #
      # See:
      #   - https://www.w3.org/TR/activitystreams-vocabulary/#dfn-object
      #   - https://www.w3.org/TR/activitystreams-vocabulary/#dfn-note
      def self.to_federation(entity, content:, name: nil, custom: {})
        # Merge default and custom contexts
        context = Utils::Context.generate(additional: custom.delete("@context"))
        # Merge in standard Article fields
        custom.merge "@context"     => context,
                     "id"           => entity.federated_url,
                     "type"         => "Article",
                     "name"         => name,
                     "content"      => content,
                     "attributedTo" => entity.fedipub_actor.federated_url,
                     "published"    => entity.created_at,
                     "updated"      => entity.updated_at
      end
    end
  end
end
