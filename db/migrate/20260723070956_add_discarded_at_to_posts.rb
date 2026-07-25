class AddDiscardedAtToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :discarded_at, :datetime
  end
end
