require "rails_helper"

describe InspectionForm do
  it 'creates a single inspection given one inspection_type_id' do 
    form = InspectionForm.new(inspection_params)
    expect(form.save).to be_truthy
    expect(form.inspections.count).to eq(1)
    expect(form.inspections.first).to be_kind_of(Inspection)
    inspection = form.inspections.first
    inspection.reload
    expect(inspection.address).to be_kind_of(Address)
  end

  it 'fails when there is no inspection_type_id' do
    form = InspectionForm.new(inspection_params(type_ids: ""))
    expect(form.save).to be_falsey
    expect(form.inspections.count).to eq(0)
  end

  it 'creates multiple inspections given multiple inspection_type_ids' do
    type_ids = create_list(:inspection_type, 2).map(&:id).join(",")
    form = InspectionForm.new(inspection_params(type_ids: type_ids))
    expect(form.save).to be_truthy
    expect(form.inspections.count).to eq(2)

    form.inspections.each do |inspection|
      inspection.reload
      expect(inspection.address).to be_kind_of(Address)
    end
    # expect(form.inspections.select{|i| i.address.present?}.count).to eq(2)
  end

  def inspection_params(type_ids: nil)
    type_ids ||= create(:inspection_type).id

    {
      "permit_number"=>"BRMD12314",
      "contact_name"=>"Test Test",
      "contact_phone"=>"4087845058",
      "contact_phone_can_text"=>"1",
      "contact_email"=>"markrossetti@codeforamerica.org",
      "inspection_type_id"=>type_ids.to_s,
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
