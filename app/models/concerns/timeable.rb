# TODO: Not being used anywhere.
module Timeable
  def check_end_time_greater_than_start_time
    unless start_at < end_at
      errors[:base] << 'End time should be greater than start time.'
    end
  end
end