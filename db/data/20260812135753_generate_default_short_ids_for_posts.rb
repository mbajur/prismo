# frozen_string_literal: true

class GenerateDefaultShortIdsForPosts < ActiveRecord::Migration[8.1]
  def up
    Post.find_each do |post|
      post.update!(short_id: post.id)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
