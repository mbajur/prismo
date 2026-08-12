class AddShortIdToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :short_id, :string
    add_index :posts, :short_id, unique: true
  end
end
