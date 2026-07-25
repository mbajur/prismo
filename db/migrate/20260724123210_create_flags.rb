class CreateFlags < ActiveRecord::Migration[8.1]
  def change
    create_table :flags do |t|
      t.references :actor, polymorphic: true, null: false
      t.references :flaggable, polymorphic: true, null: false
      t.text :summary
      t.boolean :action_taken, default: false

      t.timestamps
    end
  end
end
