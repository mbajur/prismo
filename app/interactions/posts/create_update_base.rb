# frozen_string_literal: true

class Posts::CreateUpdateBase < ActiveInteraction::Base
  object :user, class: "User"

  string :url, default: nil
  string :title
  string :tag_list
  string :description, default: nil

  validates :title, presence: true
  validate :min_tags_amount
  validate :max_tags_amount

  private

  def tags
    tag_list.split(",").map(&:strip)
  end

  def url_or_description_required
    return if url.present? || description.present?

    errors.add(:url, "is required when content is empty") if description.blank?
    errors.add(:description, "is required when URL is empty") if url.blank?
  end

  def min_tags_amount
    return if Setting.min_post_tags.zero?
    return if tags.length >= Setting.min_post_tags

    errors.add(:tag_list, "needs to have at least #{Setting.min_post_tags} tags selected")
  end

  def max_tags_amount
    return if Setting.max_post_tags.zero?
    return if tags.length <= Setting.max_post_tags

    errors.add(:tag_list, "needs to have at most #{Setting.max_post_tags} tags selected")
  end
end
