FactoryBot.define do
  factory :patient do
    sequence(:email) { |n| "patient#{n}@example.com" }
    health_identifier { SecureRandom.hex(8) }
    health_province { "Alberta" }
    first_name { "John" }
    last_name { "Doe" }
    sex { 'male' }
    phone_number { '1234567890' }

    association :address, factory: :address, strategy: :build
  end
end
