class Customer < User

  # Validations
  validates :password, presence: :true, on: :create
  validates :password, format: { with: PASSWORD_VALIDATOR_REGEX, message: 'can not include spaces.' }

  # Associations
  has_many :appointments, dependent: :restrict_with_error
  has_many :appointed_services, through: :appointments, source: 'Service', foreign_key: 'service_id'
  has_many :appointed_staffs, through: :appointments, source: 'Staff', foreign_key: 'staff_id'

  attr_accessor :time, :days

  def reminder_hours
    (reminder_time_lapse % 1440) / 60
  end

  def reminder_minutes
    (reminder_time_lapse % 1440) % 60
  end

  def reminder_days
    reminder_time_lapse / 1440
  end

  # [rai] please refactor this method(discuss)
  def change_appointments_reminder_time(old_reminder_time_lapse, new_reminder_time_lapse)
    appointments.each do |appointment|
      if appointment.start_at > Time.current
        if(old_reminder_time_lapse > new_reminder_time_lapse)
          appointment.increase_reminder_time
        elsif(new_reminder_time_lapse > old_reminder_time_lapse)
          appointment.decrease_reminder_time
        end
      end
    end
  end

end