class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.string :url
      t.string :url_domain
      t.string :title
      t.text :description
      t.integer :likes_count, null: false, default: 0
      t.integer :dislikes_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.datetime :modified_at
      t.integer :modified_count, null: false, default: 0

      t.timestamps
    end
  end
end
