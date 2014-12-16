FactoryGirl.define do
  factory :availability do
    association :staff
    # association :services, factory: :service
    start_at DateTime.now + 10.minutes
    end_at DateTime.now + 5.hours + 10.minutes
    start_date Date.today
    end_date Date.today + 5.days
    enabled true
  end
end
