class ChangeDetailsInAvailability < ActiveRecord::Migration
  def change
  	change_table :availabilities do |t|
      t.remove :start_time
      t.remove :end_time
      t.integer :start_time
      t.integer :end_time
  	end
  end
end
