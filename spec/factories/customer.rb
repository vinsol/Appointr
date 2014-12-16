FactoryGirl.define do
  factory :customer do
  name 'foo'
  password '11111111'
  password_confirmation { |u| u.password }
  sequence(:email) { |n| "foo#{ n }@gamil.com" }
  enabled true
  end
end