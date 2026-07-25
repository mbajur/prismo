class CreateFollows < ActiveRecord::Migration[8.1]
  def change
    create_table :follows do |t|
      t.references :follower, polymorphic: true, null: false
      t.references :following, polymorphic: true, null: false

      t.timestamps
    end
  end
end
