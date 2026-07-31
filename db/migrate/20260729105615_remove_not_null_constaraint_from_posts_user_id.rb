class RemoveNotNullConstaraintFromPostsUserId < ActiveRecord::Migration[8.1]
  def change
    change_column_null :posts, :user_id, true
  end
end
