require "rails_helper"

describe InspectionForm do
  it 'creates a single inspection given one inspection_type_id' do 
    form = InspectionForm.new(inspection_params)
    expect(form.save).to be_truthy
    expect(form.inspections.count).to eq(1)
  end

  def inspection_params(type_id: nil)
    type_id ||= create(:inspection_type).id

    {
      "permit_number"=>"BRMD12314",
      "contact_name"=>"Test Test",
      "contact_phone"=>"4087845058",
      "contact_phone_can_text"=>"1",
      "contact_email"=>"markrossetti@codeforamerica.org",
      "inspection_type_id"=>type_id.to_s,
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
  end
end

