class AddFedipubActorToComments < ActiveRecord::Migration[8.1]
  def change
    add_reference :comments, :fedipub_actor, null: true, foreign_key: { to_table: :fedipub_actors }
  end
end
