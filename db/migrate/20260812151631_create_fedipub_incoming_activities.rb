class CreateFedipubIncomingActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :fedipub_incoming_activities do |t|
      t.text :data, null: false
      t.string :status, null: false
      t.string :entity_class, null: false

      t.timestamps
    end
  end
end
