class Comment < ApplicationRecord
  include Discard::Model
  include SearchCop

  HOT_DAYS_LIMIT = 40

  has_closure_tree

  belongs_to :post, counter_cache: true
  belongs_to :user, optional: true
  belongs_to :parent, class_name: "Comment", optional: true

  validates :body, presence: true

  search_scope :search do
    attributes :body
  end

  def cache_depth
    update_attribute(:depth_cached, depth)
  end

  def cache_body
    update_attribute(:body_html, BodyParser.new(body).call)
  end

  before_discard do
    self.user = nil
    self.body = nil
    self.body_html = nil
  end
end
