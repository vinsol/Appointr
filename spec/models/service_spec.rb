require 'rails_helper'

RSpec.describe Service do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive }
  it { should validate_inclusion_of(:duration).in_array(Service::ALLOWED_DURATIONS) }
  it { should validate_inclusion_of(:enabled).in_array([true, false]) }
  it { should have_many(:allocations).dependent(:restrict_with_error) }
  it { should have_many(:staffs).through(:allocations) }
end