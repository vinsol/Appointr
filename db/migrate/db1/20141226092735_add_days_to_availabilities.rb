class AddDaysToAvailabilities < ActiveRecord::Migration
  def change
    add_column :availabilities, :days, :integer, array: true
  end
end
