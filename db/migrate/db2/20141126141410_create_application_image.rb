class CreateApplicationImage < ActiveRecord::Migration
  def change
    create_table :application_images do |t|
      t.string :type
    end
  end
end
