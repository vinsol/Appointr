class ChangeDetailsInAppointments < ActiveRecord::Migration
  def up
    remove_column :appointments, :start_at
    add_column :appointments, :start_at, :datetime
  end

  def down
    remove_column :appointments, :start_at
    add_column :appointments, :start_at, :time
  end
end
