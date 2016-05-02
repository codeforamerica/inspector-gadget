require 'rails_helper'

describe InspectionsController do
  it '#show should return 200 for a valid inspection' do
    get :show, id: create(:inspection).id
    expect(response.response_code).to eq(200)
  end

  it '#confirmation should 200 when visited with valid inspection params' do
    get :confirmation, inspection_ids: create_list(:inspection, 2).map(&:id).join(',') # inspection_ids=1,2
    expect(response.response_code).to eq(200)
    expect(assigns(:inspections).length).to eq(2)
  end

  it '#create with multiple inspection_type_ids should create multiple inspections' do
    allow(request).to receive(:referer).and_return('') # anything will do, just not `nil`
    type_ids = create_list(:inspection_type, 2).map(&:id).join(",")
    params = inspection_params(type_ids: type_ids)

    expect{ 
      post :create, inspection: params
    }.to change{Inspection.count}.by(2)
  end

  it '#create should redirect to a confirmation page after creating multiple inspections' do
    allow(request).to receive(:referer).and_return('') # anything will do, just not `nil`
    type_ids = create_list(:inspection_type, 2).map(&:id).join(",")
    params = inspection_params(type_ids: type_ids)

    post :create, inspection: params
    expect(response.redirect_url).to match(%r{http://test.host/inspections/confirmation\?inspection\_ids\=})
  end

  it '#create should redirect to the express confirmation page when coming from express form' do
    allow(request).to receive(:referer).and_return('/inspections/new_express')

    post :create, inspection: inspection_params
    expect(response.redirect_url).to match(%r{http://test.host/inspections/confirmation\?express\=true\&inspection\_ids\=})
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
      "requested_for_date"=>Date.tomorrow.strftime("%m/%d/%Y"),
      "requested_for_time"=>"",
      "address_notes"=>"",
      "address_attributes"=>{
        "street_number"=>"333",
        "route"=>"West Ocean Blvd",
        "city"=>"Long Beach",
        "state"=>"CA",
        "zip"=>"90802",
      }
    }
  end

end
