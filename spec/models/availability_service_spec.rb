require 'rails_helper'

RSpec.describe AvailabilityService do
  it { should belong_to(:availability) }
  it { should belong_to(:service) }
end