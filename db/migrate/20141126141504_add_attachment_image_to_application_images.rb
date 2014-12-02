class AddAttachmentImageToApplicationImages < ActiveRecord::Migration
  def self.up
    change_table :application_images do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :application_images, :image
  end
end
