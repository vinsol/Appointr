class AddDaysToAvailabilities < ActiveRecord::Migration
  def change
    add_column :availabilities, :days, :integer, array: true, default: [0, 1, 2, 3, 4, 5, 6]
  end
end
