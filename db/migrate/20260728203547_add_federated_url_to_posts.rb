class AddFederatedUrlToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :federated_url, :string
  end
end
