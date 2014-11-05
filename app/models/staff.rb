class Staff < User
  validates :designation, presence: true
end