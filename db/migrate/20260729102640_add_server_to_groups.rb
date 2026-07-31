class AddServerToGroups < ActiveRecord::Migration[8.1]
  def change
    add_column :groups, :server, :string
  end
end
