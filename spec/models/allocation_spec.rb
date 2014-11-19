require 'rails_helper'

RSpec.describe Allocation do
  it { should belong_to(:service) }
  it { should belong_to(:staff) }
end