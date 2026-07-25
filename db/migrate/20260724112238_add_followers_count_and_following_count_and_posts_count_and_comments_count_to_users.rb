class AddFollowersCountAndFollowingCountAndPostsCountAndCommentsCountToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :followers_count, :integer, default: 0, null: false
    add_column :users, :following_count, :integer, default: 0, null: false
    add_column :users, :posts_count, :integer, default: 0, null: false
    add_column :users, :comments_count, :integer, default: 0, null: false
  end
end
