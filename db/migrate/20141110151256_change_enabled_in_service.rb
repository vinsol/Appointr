class ChangeEnabledInService < ActiveRecord::Migration
  def change
    change_table :services do |t|
      t.rename :enabled?, :enabled
    end
  end
end
