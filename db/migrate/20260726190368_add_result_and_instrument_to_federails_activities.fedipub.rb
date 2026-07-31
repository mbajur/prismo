# This migration comes from fedipub (originally 20260421170640)
class AddResultAndInstrumentToFederailsActivities < ActiveRecord::Migration[7.2]
  def change
    add_column :federails_activities, :result, :string
    add_column :federails_activities, :instrument, :string
  end
end
