class CreateGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :slug
      t.boolean :supergroup, default: false

      t.timestamps
    end
  end
end
