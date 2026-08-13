class ChangeFedipubIncomingActivityDataToJson < ActiveRecord::Migration[8.1]
  def change
    change_column :fedipub_incoming_activities, :data, :json
  end
end
