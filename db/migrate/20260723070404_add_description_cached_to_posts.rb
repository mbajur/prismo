class AddDescriptionCachedToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :description_cached, :text
  end
end
