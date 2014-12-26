FactoryGirl.define do
  factory :appointment do
    association :staff
    association :customer
    association :service
    duration 30
    start_at DateTime.current + 20.minutes
  end
end