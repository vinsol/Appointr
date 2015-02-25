class ApplicationImage < Db2

  # [rai] no validation for the size limit?(fixed)
  has_attached_file :image, :styles => { medium: "300x300>", thumb: "100x100>" }
  validates_attachment :image, :presence => true,
  :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] },
  :size => { :in => 0..1.megabytes }
  # [rai] how are we using this?([gaurav] we are not. so i removed it)
end