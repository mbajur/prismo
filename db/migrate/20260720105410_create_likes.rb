class CreateLikes < ActiveRecord::Migration[8.1]
  def change
    create_table :likes do |t|
      t.references :likeable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
