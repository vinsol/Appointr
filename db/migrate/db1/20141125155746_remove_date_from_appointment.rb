class RemoveDateFromAppointment < ActiveRecord::Migration
  def up
    remove_column :appointments, :date
  end
  def down
    add_column :appointments, :date, :date
  end
end
