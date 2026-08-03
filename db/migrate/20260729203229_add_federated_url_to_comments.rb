class AddFederatedUrlToComments < ActiveRecord::Migration[8.1]
  def change
    add_column :comments, :federated_url, :string
  end
end
