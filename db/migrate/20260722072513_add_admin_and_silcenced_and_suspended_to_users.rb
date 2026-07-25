class AddAdminAndSilcencedAndSuspendedToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :silenced, :boolean, default: false
    add_column :users, :suspended, :boolean, default: false
  end
end
