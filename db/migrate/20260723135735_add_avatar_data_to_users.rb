class AddAvatarDataToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :avatar_data, :json
  end
end
