class AddReminderJobIdToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :reminder_job_id, :integer
  end
end
