class AddDetailsToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :attended, :boolean
    add_column :appointments, :remarks, :text
  end
end
