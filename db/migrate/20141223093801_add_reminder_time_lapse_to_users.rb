class AddReminderTimeLapseToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reminder_time_lapse, :integer, default: 240
  end
end
