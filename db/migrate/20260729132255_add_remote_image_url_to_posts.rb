class AddRemoteImageUrlToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :remote_image_url, :string
  end
end
