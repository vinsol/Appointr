class CreateAvailabity < ActiveRecord::Migration
  def change
    create_table :availabities do |t|
      t.belongs_to :staff
      t.time :start_time
      t.time :end_time
      t.date :start_date
      t.date :end_date

      t.time_stamps
    end
  end
end
