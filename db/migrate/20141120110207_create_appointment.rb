class CreateAppointment < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.belongs_to :staff
      t.belongs_to :service
      t.belongs_to :customer
      t.time :start_at
      t.integer :duration
      t.date :date

      t.timestamps
    end
  end
end
