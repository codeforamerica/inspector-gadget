FactoryGirl.define do
  factory :inspection do
    permit_number "BRMD12314"
    contact_name { Faker::Name.name }
    contact_phone { Faker::PhoneNumber.phone_number }
    contact_phone_can_text "1"
    contact_email { Faker::Internet.email }
    inspection_type { InspectionType.order('random()').first }
    inspection_notes ""
    requested_for_date "Wed, 20 Apr 2016"
    requested_for_time ""
    address_notes ""
  end
end
