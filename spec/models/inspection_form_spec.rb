require "rails_helper"

INSPECTION_PARAMS = {
  "permit_number"=>"BRMD12314",
  "contact_name"=>"Test Test",
  "contact_phone"=>"4087845058",
  "contact_phone_can_text"=>"1",
  "contact_email"=>"markrossetti@codeforamerica.org",
  "inspection_type_id"=>"3346",
  "inspection_notes"=>"",
  "requested_for_date"=>"Wed,
  20 Apr 2016",
  "requested_for_time"=>"",
  "address_notes"=>"",
  "address_attributes"=>{
    "street_number"=>"55",
    "route"=>"Potomac Trail",
    "city"=>"Newnan",
    "state"=>"GA",
    "zip"=>"30263",
  }
}

describe InspectionForm do
  it 'creates a single inspection given one inspection_type_id' do 
    form = InspectionForm.new(INSPECTION_PARAMS)
    expect(form.save).to be_truthy
    expect(form.inspections.count).to eq(1)
  end
end


