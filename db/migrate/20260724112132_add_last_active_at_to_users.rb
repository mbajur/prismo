class AddLastActiveAtToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :last_active_at, :datetime
  end
end
