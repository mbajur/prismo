class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.references :post, null: false, foreign_key: { to_table: :posts }
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.text :body
      t.references :parent, null: true, foreign_key: { to_table: :comments }
      t.integer :likes_count, default: 0, null: false
      t.integer :children_count, default: 0, null: false
      t.integer :depth_cached, default: 0, null: false
      t.text :body_html

      t.timestamps
    end
  end
end
