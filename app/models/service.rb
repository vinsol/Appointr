class Service < ActiveRecord::Base

  Durations = [['15 min', 15], ['30 min', 30], ['45 min', 45], ['1 hour', 60]]
  EnabledOptions = [true, false]

  validates :name, presence: true
  validates :duration, inclusion: { in: Durations.map { |duration| duration[1] } }
  validates :enabled?, inclusion: { in: EnabledOptions } 
end