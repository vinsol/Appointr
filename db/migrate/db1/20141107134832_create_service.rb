class CreateService < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.integer :duration
      t.boolean :enabled?, default: true
    end
  end
end
