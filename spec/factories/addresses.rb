FactoryBot.define do
  factory :address do
    apartment { 'Apt 3' }
    street_address { "123 Main Street" }
    city { "Calgary" }
    province { "Alberta" }
    postal_code { "T2P 1A1" }
    country { "Canada" }

    factory :patient_address do 
      association :addressable, factory: :patient
    end

  end
end
