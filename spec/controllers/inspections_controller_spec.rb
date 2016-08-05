require 'rails_helper'

describe InspectionsController do

  it '#confirmation should 200 when visited with valid inspection params' do
    get :confirmation, inspection_ids: create_list(:inspection, 2).map(&:id).join(',') # inspection_ids=1,2
    expect(response.response_code).to eq(200)
    expect(assigns(:inspections).length).to eq(2)
  end

  it '#create with multiple inspection_type_ids should create multiple inspections' do
    allow(request).to receive(:referer).and_return('') # anything will do, just not `nil`
    type_ids = InspectionType.commercial.order('random()').limit(2).pluck(:id).join(",")
    params = inspection_params(type_ids: type_ids)

    expect{
      post :create, inspection: params
    }.to change{Inspection.count}.by(2)
  end

  it '#create should redirect to a confirmation page after creating multiple inspections' do
    allow(request).to receive(:referer).and_return('') # anything will do, just not `nil`
    type_ids = InspectionType.commercial.order('random()').limit(2).pluck(:id).join(",")
    params = inspection_params(type_ids: type_ids)

    post :create, inspection: params
    expect(response.redirect_url).to match(%r{http://test.host/inspections/confirmation\?inspection\_ids\=})
  end

  it '#create should redirect to the express confirmation page when coming from express form' do
    allow(request).to receive(:referer).and_return('/inspections/new_express')

    post :create, inspection: inspection_params
    expect(response.redirect_url).to match(%r{http://test.host/inspections/confirmation\?express\=true\&inspection\_ids\=})
  end

  it '#should return ordered inspections by inspector name' do
    inspections = [
      create(:address, street_number: '4350', route: 'Sunfield Ave', city: 'Long Beach', state: 'CA', zip: '').inspection,  # Flacks
      create(:address, street_number: '3067', route: 'Charlemagne', city: 'Long Beach', state: 'CA', zip: '').inspection,   # Ciarrelli
      create(:address, street_number: '2326', route: 'Olive Ave', city: 'Long Beach', state: 'CA', zip: '').inspection      # Reza
    ]

    tomorrow = Date.tomorrow
    residential_inspection_type = InspectionType.residential.first
    inspections.each do |i|
      i.update_attributes(
        requested_for_date: tomorrow,
        inspection_type: residential_inspection_type
      )
    end

    get :print, date: Date.tomorrow
    expected_results = [['Ciarrelli', 'Flacks', 'Reza'], ['', '', '']]
    expect(assigns(:inspection_cards).map{ |i| i['inspector'] }).to be_in(expected_results)
  end

  it 'should combine residential inspections' do
    residentials = [
      create(:address, street_number: '4350', route: 'Sunfield Ave', city: 'Long Beach', state: 'CA', zip: '').inspection,
      create(:address, street_number: '4350', route: 'Sunfield Ave', city: 'Long Beach', state: 'CA', zip: '').inspection
    ]
    commercials = [
      create(:address, street_number: '4350', route: 'Sunfield Ave', city: 'Long Beach', state: 'CA', zip: '').inspection,
      create(:address, street_number: '4350', route: 'Sunfield Ave', city: 'Long Beach', state: 'CA', zip: '').inspection
    ]

    residential_inspection_type = InspectionType.residential.first
    residentials.each do |i|
      i.update_attributes(
        requested_for_date: Date.today,
        inspection_type: residential_inspection_type
      )
    end

    commercial_inspection_type = InspectionType.commercial.first
    commercials.each do |i|
      i.update_attributes(
        requested_for_date: Date.today,
        inspection_type: commercial_inspection_type
      )
    end

    get :print, date: Date.today
    expect(assigns(:inspection_cards).count).to eq(3) # residentials combined
  end

  def inspection_params(type_ids: nil)
    type_ids ||= InspectionType.commercial.order('random()').first.id

    {
      "permit_number"=>"BRMD12314",
      "contact_name"=>"Test Test",
      "contact_phone"=>"4087845058",
      "contact_phone_can_text"=>"1",
      "contact_email"=>"markrossetti@codeforamerica.org",
      "inspection_type_id"=>type_ids.to_s,
      "inspection_notes"=>"",
      "requested_for_date"=>Date.today.next_week(:tuesday).strftime("%m/%d/%Y"),
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
