FactoryGirl.define do
  factory :allocation do
    association :service
    association :staff
  end
end
