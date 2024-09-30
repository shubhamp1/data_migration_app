FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "patient#{n}@example.com" }
    password { 'test_password' }
  end
end
