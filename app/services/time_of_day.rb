class TimeOfDay
  def self.set(hours, minutes)
    (hours * 3600) + (minutes * 60)
  end

  def self.get(seconds)
    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    if(hours < 10 && minutes < 10)
      "0#{ hours }:0#{ minutes }"
    elsif(hours < 10 && minutes >= 10)
      "0#{ hours }:#{ minutes }"
    elsif(hours >= 10 && minutes < 10)
      "#{ hours }:0#{ minutes }"
    else
      "#{ hours }:#{ minutes }"
    end
  end
end