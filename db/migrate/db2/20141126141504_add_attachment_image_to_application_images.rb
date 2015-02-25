class AddAttachmentImageToApplicationImages < ActiveRecord::Migration
  include Paperclip::Glue
  def self.up
    add_attachment :application_images, :image
    # change_table :application_images do |t|
    # end
  end

  def self.down
    remove_attachment :application_images, :image
  end
end
