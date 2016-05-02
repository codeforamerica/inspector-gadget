require 'rails_helper'

describe Inspection do
  describe '#inspector', :ci_skip do
    
    it "returns the correct inspector" do
      inspection = create(:address, street_number: '2061', route: 'Snowden', city: 'Long Beach', state: 'CA', zip: '').inspection
      inspection.inspection_type = create(:inspection_type_residential)
      expect(inspection.inspector.name).to eq('Lloyd')
    end

    it "returns the correct inspector" do
      inspection = create(:address, street_number: '4350', route: 'Sunfield Ave', city: 'Long Beach', state: 'CA', zip: '').inspection
      inspection.inspection_type = create(:inspection_type_residential)
      expect(inspection.inspector.try(:name)).to eq('Flacks')
    end

    it "returns the correct inspector" do
      inspection = create(:address, street_number: '2326', route: 'Olive Ave', city: 'Long Beach', state: 'CA', zip: '').inspection
      inspection.inspection_type = create(:inspection_type_residential)
      expect(inspection.inspector.try(:name)).to eq('Reza')
    end

    it "returns the correct inspector" do
      inspection = create(:address, street_number: '3067', route: 'Charlemagne', city: 'Long Beach', state: 'CA', zip: '').inspection
      inspection.inspection_type = create(:inspection_type_residential)
      expect(inspection.inspector.try(:name)).to eq('Ciarrelli')
    end

    it "returns the correct inspector" do
      inspection = create(:address, street_number: '2821', route: 'Daisy Ave', city: 'Long Beach', state: 'CA', zip: '').inspection
      inspection.inspection_type = create(:inspection_type_residential)
      expect(inspection.inspector.try(:name)).to eq('Mann')
    end

    it "returns the correct inspector" do
      inspection = create(:address, street_number: '1911', route: 'E 63rd St', city: 'Long Beach', state: 'CA', zip: '').inspection
      inspection.inspection_type = create(:inspection_type_residential)
      expect(inspection.inspector.try(:name)).to eq('Morey')
    end

    xit "returns the correct inspector" do # No GIS data available for this inspector
      inspection = create(:address, street_number: '2640', route: 'Lakewood Blvd', city: 'Long Beach', state: 'CA', zip: '').inspection
      inspection.inspection_type = create(:inspection_type)
      expect(inspection.inspector.name).to eq('Varnes')
    end

    xit "returns the correct inspector" do # Something fishy about the GIS data for this inspector. See https://github.com/rgeo/rgeo/issues/113
      inspection = create(:address, street_number: '2020', route: 'W Pacific Coast Highway', city: 'Long Beach', state: 'CA', zip: '').inspection
      inspection.inspection_type = create(:inspection_type)
      expect(inspection.inspector.name).to eq('Nicholls')
    end
  end
end
