class ApplicationImage < ActiveRecord::Base

  # [rai] no validation for the size limit?
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates :image, presence: true

  # [rai] how are we using this?
  def self.types
    %w(BackGround Logo)
  end
end