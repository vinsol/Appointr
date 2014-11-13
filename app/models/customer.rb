class Customer < User
  validates :password, presence: :true
  validates :password, format: { with: /\A[^\s]+\z/i, message: 'can not include spaces.' }

end