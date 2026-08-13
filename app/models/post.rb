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

  acts_as_fedipub_data handles: [ "Page", "Article" ],
                       soft_deleted_method: :discarded?,
                       soft_delete_date_method: :discarded_at,
                       actor_entity_method: :user,
                       route_path_segment: :posts,
                       url_param: :short_id,
                       with: :handle_incoming_fediverse_data_async

  on_fedipub_delete_requested :discard

  after_create :create_group_announce, if: :local_fedipub_entity?
  before_validation :assign_defaults, on: :create

  def self.find_by_short_id(short_id)
    find_by(short_id:)
  end

  def self.find_by_short_id!(short_id)
    find_by!(short_id:)
  end

  def self.find_by_short_id_or_id!(short_id_or_id)
    find_by(short_id: short_id_or_id) || find(short_id_or_id)
  end

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
                                                      content: description_cached,
                                                      custom: {
                                                        "tag" => tags.map do |tag|
                                                          {
                                                            "type" => "Hashtag",
                                                            "name" => "##{tag.name}",
                                                            "href" => Rails.application.routes.url_helpers.tag_posts_url(tag)
                                                          }
                                                        end,
                                                        "audience" => group.fedipub_actor.federated_url,
                                                        "to" => [
                                                          group.fedipub_actor.federated_url,
                                                          Fediverse::Collection::PUBLIC
                                                        ]
                                                      }
    else
      Fedipub::DataTransformer::Page.to_federation self,
                                                   name:    title,
                                                   content: description_cached,
                                                   custom: {
                                                     "tag" => tags.map do |tag|
                                                       {
                                                         "type" => "Hashtag",
                                                         "name" => "##{tag.name}",
                                                         "href" => Rails.application.routes.url_helpers.tag_posts_url(tag)
                                                       }
                                                     end,
                                                     "audience" => group.fedipub_actor.federated_url,
                                                     "to" => [
                                                       group.fedipub_actor.federated_url,
                                                       Fediverse::Collection::PUBLIC
                                                     ]
                                                   }
    end
  end

  def self.handle_incoming_fediverse_data_async(activity_hash_or_id)
    incoming_activity = Fedipub::IncomingActivity.create!(
      entity_class: self.name,
      data: activity_hash_or_id
    )
    Fedipub::IncomingFediverseDataHandlerJob.perform_later(incoming_activity)
  end

  # @todo extract that to a service
  def self.handle_incoming_fediverse_data(activity_hash_or_id)
    activity = Fediverse::Request.dereference(activity_hash_or_id)
    object = Fediverse::Request.dereference(activity["object"])

    entity = Fedipub::Utils::Object.find_or_create!(object)

    if activity["type"] == "Update"
      entity.assign_attributes from_activitypub_object(object)

      # Use timestamps from attributes
      entity.save! touch: false
    end

    entity
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
      likes_count: Like.where(likeable: self).count
    )
  end

  def create_group_announce
    announce!(actor: group.fedipub_actor)
  end

  def to_param
    short_id
  end

  private

  def assign_defaults
    self.short_id ||= ShortId.new(self.class).generate
  end
end
