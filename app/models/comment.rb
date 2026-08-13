class Comment < ApplicationRecord
  include Discard::Model
  include SearchCop
  include Fedipub::DataEntity

  HOT_DAYS_LIMIT = 40

  has_closure_tree

  belongs_to :post, counter_cache: true
  belongs_to :user, optional: true
  belongs_to :parent, class_name: "Comment", optional: true

  validates :body, presence: true

  search_scope :search do
    attributes :body
  end

  acts_as_fedipub_data handles: [ "Note" ],
                       soft_deleted_method: :discarded?,
                       soft_delete_date_method: :discarded_at,
                       actor_entity_method: :user,
                       route_path_segment: :comments,
                       with: :handle_incoming_fediverse_data_async

  on_fedipub_delete_requested :discard

  # Handle only notes that are replies to something. Either to post or another
  # note
  def self.handle_federated_object?(hash)
    hash["inReplyTo"].present?
  end

  def self.from_activitypub_object(hash)
    raise "No parent defined in object" if hash["inReplyTo"].blank?

    attrs = Fedipub::Utils::Object.timestamp_attributes(hash)
                                  .merge federated_url: hash["id"],
                                         body:         hash["content"]

    parent_or_post = Fedipub::Utils::Object.find_or_create! hash["inReplyTo"]

    if parent_or_post.is_a? Post
      attrs[:post] = parent_or_post
    elsif parent_or_post.is_a? Comment
      attrs[:post] = parent_or_post.post
      attrs[:parent] = parent_or_post
    end

    attrs
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

  def to_activitypub_object
    parent_or_post = parent || post

    Fedipub::DataTransformer::Note.to_federation self,
                                                 content: body,
                                                 custom: {
                                                   "inReplyTo" => parent_or_post.federated_url
                                                 }
  end

  def cache_depth
    update_attribute(:depth_cached, depth)
  end

  def cache_body
    update_attribute(:body_html, BodyParser.new(body).call)
  end

  def cache_likes
    update(
      likes_count: Like.where(likeable: self).count
    )
  end

  before_discard do
    self.user = nil
    self.body = nil
    self.body_html = nil
  end

  after_discard do
    create_fedipub_activity "Delete" if local_fedipub_entity?
  end

  # @todo move that to Fedipub
  def like!(actor:)
    if local_fedipub_entity?
      super
    else
      Fedipub::Activity.create!(action: "Like", actor: actor, entity: self)
    end
  end
end
