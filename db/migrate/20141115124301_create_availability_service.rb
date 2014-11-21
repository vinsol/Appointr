class CreateAvailabilityService < ActiveRecord::Migration
  def change
    create_table :availability_services do |t|
      t.belongs_to :service
      t.belongs_to :availability

      t.timestamps
    end
  end
end
