class CreateFedipubMentions < ActiveRecord::Migration[8.1]
  def change
    create_table :fedipub_mentions do |t|
      t.references :entity, polymorphic: true, null: false
      t.references :actor, null: false, foreign_key: { to_table: :fedipub_actors }
      t.datetime :discarded_at

      t.timestamps
    end
  end
end
