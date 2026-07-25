class Post < ApplicationRecord
  include Discard::Model
  include SearchCop

  HOT_DAYS_LIMIT = 40

  Gutentag::ActiveRecord.call(self)

  belongs_to :user
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
end
