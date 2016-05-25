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
    type_ids = InspectionType.commercial.order('random()').limit(2).pluck(:id).join(",")
    form = InspectionForm.new(inspection_params(type_ids: type_ids))
    expect(form.save).to be_truthy
    expect(form.inspections.count).to eq(2)

    form.inspections.each do |inspection|
      inspection.reload
      expect(inspection.address).to be_kind_of(Address)
    end
    # expect(form.inspections.select{|i| i.address.present?}.count).to eq(2)
  end

  describe '#save' do

    it 'should return false if requested_for_date is in the past' do
      params = inspection_params.merge("requested_for_date" => Date.yesterday)
      form = InspectionForm.new(params)
      expect(form.save).to be_falsey
    end

    it 'should return false if requested_for_date is on a weekend' do
      params = inspection_params.merge("requested_for_date" => Date.current.next_week(:sunday))
      form = InspectionForm.new(params)
      expect(form.save).to be_falsey
    end

    it "should return false if requested_for_date is on a holiday (New Year's Day (observed))" do
      params = inspection_params.merge("requested_for_date" => Date.civil(2017, 1, 2))
      form = InspectionForm.new(params)
      expect(form.save).to be_falsey
    end

    it "should return false if requested_for_date is on a holiday (Memorial Day)" do
      params = inspection_params.merge("requested_for_date" => Date.civil(2016, 5, 30))
      form = InspectionForm.new(params)
      expect(form.save).to be_falsey
    end

  end

  describe '#requested_for_date_must_not_be_weekend' do
    it 'should return false if requested_for_date is not on a weekend' do
      params = inspection_params.merge("requested_for_date" => Date.current.next_week(:wednesday))
      form = InspectionForm.new(params)
      form.validate
      expect(form.errors[:requested_for_date]).not_to include("must not be a weekend")
    end

    it 'should return false if requested_for_date is on a weekend' do
      params = inspection_params.merge("requested_for_date" => Date.current.next_week(:sunday))
      form = InspectionForm.new(params)
      form.validate
      expect(form.errors[:requested_for_date]).to include("must not be a weekend")
    end
  end

  describe '#requested_for_date_must_not_be_holiday' do
    it "should return true if requested_for_date is not on a holiday" do
      params = inspection_params.merge("requested_for_date" => Date.civil(2016, 5, 25))
      form = InspectionForm.new(params)
      form.validate
      expect(form.errors[:requested_for_date]).not_to include("must not be a holiday")
    end

    it "should return false if requested_for_date is on a holiday (New Year's Day (observed))" do
      params = inspection_params.merge("requested_for_date" => Date.civil(2017, 1, 2))
      form = InspectionForm.new(params)
      form.validate
      expect(form.errors[:requested_for_date]).to include("must not be a holiday")
    end

    it "should return false if requested_for_date is on a holiday (Memorial Day)" do
      params = inspection_params.merge("requested_for_date" => Date.civil(2016, 5, 30))
      form = InspectionForm.new(params)
      form.validate
      expect(form.errors[:requested_for_date]).to include("must not be a holiday")
    end
  end

  def inspection_params(type_ids: nil)
    type_ids ||= InspectionType.commercial.order('random()').first.id

    {
      "permit_number" => "BRMD12314",
      "contact_name" => "Test Test",
      "contact_phone" => "4087845058",
      "contact_phone_can_text" => "1",
      "contact_email" => "markrossetti@codeforamerica.org",
      "inspection_type_id"=>type_ids.to_s,
      "inspection_notes" => "",
      "requested_for_date"=>Date.current.next_week(:tuesday),
      "requested_for_time" => "",
      "address_notes" => "",
      "address_attributes"=>{
        "street_number" => "333",
        "route" => "West Ocean Blvd",
        "city" => "Long Beach",
        "state" => "CA",
        "zip" => "90802",
      }
    }
  end
end
