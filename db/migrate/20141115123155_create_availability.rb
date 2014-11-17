class CreateAvailability < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.belongs_to :staff
      t.time :start_time
      t.time :end_time
      t.date :start_date
      t.date :end_date
      t.boolean :enabled

      t.timestamps
    end
  end
end
