module ServicesHelper
  def get_duration_periods
    Service::ALLOWED_DURATIONS.map do |duration_period|
      ["#{ duration_period } min", duration_period]
    end
  end
end