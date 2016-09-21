require 'rails_helper'

describe Inspection do
  describe '#inspector', :ci_skip do

    context 'for a residential inspection' do
      general_residential_inspection_types = InspectionType.residential
        .where.not(inspection_category: ['photovoltaic', 'planning'])
        .where.not(inspection_name: ['Rough Hydro for Fire Sprinkler System', 'Fire Final']) # these are handled by the 'fire' inspector
        .order('random()').first

      it 'returns the correct inspector' do
        inspection = create(:address, street_number: '2061', route: 'Snowden', city: 'Long Beach', state: 'CA', zip: '').inspection
        inspection.update_attributes(inspection_type: general_residential_inspection_types )
        expect(inspection.inspector.name).to eq('Lloyd')
      end

      it 'returns the correct inspector' do
        inspection = create(:address, street_number: '4350', route: 'Sunfield Ave', city: 'Long Beach', state: 'CA', zip: '').inspection
        inspection.update_attributes(inspection_type: general_residential_inspection_types )
        expect(inspection.inspector.try(:name)).to eq('Flacks')
      end

      it 'returns the correct inspector' do
        inspection = create(:address, street_number: '2326', route: 'Olive Ave', city: 'Long Beach', state: 'CA', zip: '').inspection
        inspection.update_attributes(inspection_type: general_residential_inspection_types )
        expect(inspection.inspector.try(:name)).to eq('Reza')
      end

      it 'returns the correct inspector' do
        inspection = create(:address, street_number: '3067', route: 'Charlemagne', city: 'Long Beach', state: 'CA', zip: '').inspection
        inspection.update_attributes(inspection_type: general_residential_inspection_types )
        expect(inspection.inspector.try(:name)).to eq('Ciarrelli')
      end

      it 'returns the correct inspector' do
        inspection = create(:address, street_number: '2821', route: 'Daisy Ave', city: 'Long Beach', state: 'CA', zip: '').inspection
        inspection.update_attributes(inspection_type: general_residential_inspection_types )
        expect(inspection.inspector.try(:name)).to eq('Mann')
      end

      it 'returns the correct inspector' do
        inspection = create(:address, street_number: '1911', route: 'E 63rd St', city: 'Long Beach', state: 'CA', zip: '').inspection
        inspection.update_attributes(inspection_type: general_residential_inspection_types )
        expect(inspection.inspector.try(:name)).to eq('Morey')
      end

      it 'returns the correct inspector for a residential photovoltaic inspection' do
        # N.B. residential PV inspections are all assigned to one inspector, regardless of location
        inspection = create(:address, street_number: '1911', route: 'E 63rd St', city: 'Long Beach', state: 'CA', zip: '').inspection
        inspection.update_attributes(inspection_type: InspectionType.residential.find_by(inspection_category: 'photovoltaic') )
        expect(inspection.inspector.try(:name)).to eq('Aaker')
      end
    end

    context 'for a commercial inspection' do

      it 'returns the correct inspector' do # No GIS data available for this inspector
        inspection = create(:address, street_number: '5433', route: 'Lemon Avenue', city: 'Long Beach', state: 'CA', zip: '').inspection
        inspection.inspection_type = InspectionType.commercial
          .where(inspection_category: 'improvements_additions_new', inspection_name: 'Slab')
          .order('random()').first
        expect(inspection.inspector.name).to eq('Aaker') # north
      end

      it 'returns the correct inspector' do # Something fishy about the GIS data for this inspector. See https://github.com/rgeo/rgeo/issues/113
        inspection = create(:address, street_number: '1000', route: 'Marietta Ct', city: 'Long Beach', state: 'CA', zip: '').inspection
        inspection.inspection_type = InspectionType.commercial
          .where(inspection_category: 'improvements_additions_new', inspection_name: 'Slab')
          .order('random()').first
        expect(inspection.inspector.name).to eq('Nicholls') # south
      end

      it 'returns the correct inspector' do
        inspection = create(:address, street_number: '2810', route: 'Eucalyptus Avenue', city: 'Long Beach', state: 'CA', zip: '90806').inspection
        inspection.inspection_type = InspectionType.commercial
          .where(inspection_category: 'improvements_additions_new', inspection_name: 'Slab')
          .order('random()').first
        expect(inspection.inspector.name).to eq('Marquez') # mid-city
      end

      it 'returns the correct inspector for a Pool - Gas Test inspection (plumbing)' do
        inspection = create(:address, street_number: '1911', route: 'E 63rd St', city: 'Long Beach', state: 'CA', zip: '').inspection
        inspection.inspection_type = InspectionType.commercial.find_by(inspection_category: 'pool', inspection_name: 'Gas Test')
        expect(inspection.inspector.name).to eq('Plumbing')
      end

      it 'returns the correct inspector for a Pool - Electrical Final inspection (electric)' do
        inspection = create(:address, street_number: '1911', route: 'E 63rd St', city: 'Long Beach', state: 'CA', zip: '').inspection
        inspection.inspection_type = InspectionType.commercial.find_by(inspection_category: 'pool', inspection_name: 'Electrical Final')
        expect(inspection.inspector.name).to eq('Ingram')
      end

    end
  end
end
