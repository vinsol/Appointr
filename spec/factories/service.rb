FactoryGirl.define do
  factory :service do
    sequence(:name) { |n| "service#{ n }" }
    duration 30
    enabled true
  end
end
# staff = FactoryGirl.create(:staff)
# service = FactoryGirl.create(:service, staff: staff)
# availability = 
# customer
