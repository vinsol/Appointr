class Allocation < ActiveRecord::Base
  belongs_to :service
  belongs_to :staff
end