class AddUndoneAtToFedipubActivities < ActiveRecord::Migration[8.1]
  def change
    add_column :fedipub_activities, :undone_at, :datetime
  end
end
