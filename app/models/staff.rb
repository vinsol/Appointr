class Staff < User
  validates :designation, presence: true
  validates :services, presence: true
  validates :password, presence: :true, if: :should_validate_password?
  validates :password, format: { with: /\A[^\s]*\z/i, message: 'can not include spaces.' }, if: :should_validate_password?
  
  has_many :allocations
  has_many :services, through: :allocations

  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  def password_required?
    super if confirmed?
  end

  def should_validate_password?
    !encrypted_password && !new_record?
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end
end