class AddUniqueConstraintToFedipubMentions < ActiveRecord::Migration[8.1]
  def change
    add_index :fedipub_mentions, [ :entity_id, :entity_type, :actor_id ], unique: true
  end
end
