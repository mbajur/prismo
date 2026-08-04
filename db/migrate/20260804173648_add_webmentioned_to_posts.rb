class AddWebmentionedToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :webmentioned, :boolean, default: false
  end
end
