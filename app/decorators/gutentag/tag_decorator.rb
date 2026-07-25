# frozen_string_literal: true

class Gutentag::TagDecorator < Draper::Decorator
  delegate_all

  def to_s
    "##{object.name}"
  end

  def path
    h.tag_stories_path(object.name)
  end

  def to_meta_tags
    {
      title: to_s,
      og: {
        title: to_s
      }
    }
  end
end
