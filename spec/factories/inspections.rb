FactoryGirl.define do
  factory :inspection do
    permit_number "BRMD12314"
    contact_name "Test Test"
    contact_phone "4087845058"
    contact_phone_can_text "1"
    contact_email "markrossetti@codeforamerica.org"
    inspection_type InspectionType.order('random()').first
    inspection_notes ""
    requested_for_date "Wed, 20 Apr 2016"
    requested_for_time ""
    address_notes ""
  end
end
