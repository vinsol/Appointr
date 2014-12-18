class AvailabilityService < ActiveRecord::Base
  belongs_to :availability
  belongs_to :service
end