class Post < ApplicationRecord
  include Discard::Model
  include SearchCop
  include Fedipub::DataEntity

  HOT_DAYS_LIMIT = 40

  Gutentag::ActiveRecord.call(self)

  belongs_to :user, optional: true
  belongs_to :group
  belongs_to :url_meta, optional: true
  has_many :comments, dependent: :destroy

  attr_accessor :tag_list

  delegate :thumb, :thumb_url, :thumb_data?,
           to: :url_meta,
           allow_nil: true

  search_scope :search do
    attributes :title, :description
  end

  # @todo handle both Page and Article
  acts_as_fedipub_data handles: [ "Page", "Article" ],
                       soft_deleted_method: :discarded?,
                       soft_delete_date_method: :discarded_at,
                       actor_entity_method: :user,
                       route_path_segment: :posts

  on_fedipub_delete_requested :discard

  after_create :create_group_announce, if: :local_fedipub_entity?

  # Only "top level" posts should be saved as Post; replies are handled by
  # Comment
  def self.handle_federated_object?(hash)
    hash["inReplyTo"].blank?
  end

  def self.from_activitypub_object(hash)
    group_actor = Fedipub::Actor.find_or_create_by_federation_url(hash["audience"])

    if group_actor.entity
      local_group = group_actor.entity
    else
      local_group = Group.find_or_initialize_by(slug: group_actor.username, server: group_actor.server) do |group|
        group.name = group_actor.name
        group.save!
      end

      group_actor.update!(entity: local_group) if group_actor.entity.nil?
    end

    if hash["type"] == "Article"
      Fedipub::Utils::Object.timestamp_attributes(hash)
                            .merge federated_url: hash["id"],
                                   title:         hash["name"],
                                   description:   hash["content"],
                                   group:         local_group
    elsif hash["type"] == "Page"
      Fedipub::Utils::Object.timestamp_attributes(hash)
                            .merge federated_url: hash["id"],
                                   title:         hash["name"],
                                   description:   hash["content"],
                                   url:           hash.dig("attachment", "href"),
                                   group:         local_group,
                                   remote_image_url: hash.dig("image", "url")
    else
      raise "Unsupported ActivityPub object type: #{hash["type"]}"
    end
  end

  def to_activitypub_object
    if article?
      Fedipub::DataTransformer::Article.to_federation self,
                                                      name:    title,
                                                      content: description_cached
    else
      Fedipub::DataTransformer::Page.to_federation self,
                                                   name:    title,
                                                   content: description_cached
    end
  end

  def article?
    !url.present?
  end

  def link?
    url.present?
  end

  def cache_description
    update(
      description_cached: BodyParser.new(description).call
    )
  end

  def cache_likes
    update(
      likes_count: Fedipub::Activity.where(action: "Like", entity: self, undone_at: nil).count
    )
  end

  def create_group_announce
    announce!(actor: group.fedipub_actor)
  end
end
