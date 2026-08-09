class ChangeLikesUserToFedipubActor < ActiveRecord::Migration[8.1]
  def change
    remove_reference :likes, :user, foreign_key: { to_table: :users }
    add_reference :likes, :fedipub_actor, foreign_key: { to_table: :fedipub_actors }
  end
end
