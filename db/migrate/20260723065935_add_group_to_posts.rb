class AddGroupToPosts < ActiveRecord::Migration[8.1]
  def change
    add_reference :posts, :group, null: true, foreign_key: { to_table: :groups }
  end
end
