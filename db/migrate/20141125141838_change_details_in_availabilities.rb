class ChangeDetailsInAvailabilities < ActiveRecord::Migration
  def up
    remove_column :availabilities, :start_time
    remove_column :availabilities, :end_time
    add_column :availabilities, :start_at, :datetime
    add_column :availabilities, :end_at, :datetime
  end

  def down
    remove_column :availabilities, :start_at
    remove_column :availabilities, :end_at
    add_column :availabilities, :start_time, :time
    add_column :availabilities, :end_time, :time
  end
end
