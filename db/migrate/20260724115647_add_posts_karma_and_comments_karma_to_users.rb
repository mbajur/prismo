class AddPostsKarmaAndCommentsKarmaToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :posts_karma, :integer, default: 0, null: false
    add_column :users, :comments_karma, :integer, default: 0, null: false
  end
end
