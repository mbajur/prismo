class AddUrlMetaToPosts < ActiveRecord::Migration[8.1]
  def change
    add_reference :posts, :url_meta, null: true, foreign_key: { to_table: :url_meta }
  end
end
