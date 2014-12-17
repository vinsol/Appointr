FactoryGirl.define do
  factory :staff do
  name 'bar'
  designation 'asdf'
  password '11111111'
  password_confirmation { |u| u.password }
  email 'bar@gmail.com'
  enabled true
  association :services, factory: :service
  end
end