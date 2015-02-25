class RemoveAttendedFromAppointment < ActiveRecord::Migration
  def up
    remove_column :appointments, :attended
  end

  def down
    add_column :appointments, :attended, :boolean
  end
end
