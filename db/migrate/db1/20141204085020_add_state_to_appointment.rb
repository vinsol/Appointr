class AddStateToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :state, :string
  end
end
