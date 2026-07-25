class AddScrappedAtToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :scrapped_at, :datetime
  end
end
