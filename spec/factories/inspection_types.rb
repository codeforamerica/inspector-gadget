FactoryGirl.define do
  factory :inspection_type do
    inspection_supercategory 'commercial'
    inspection_supercategory_name 'Commercial / Multifamily Residential / Condo'
    inspection_category 'cell_sites'
    inspection_category_name 'Cell Sites'
    inspection_name 'Building Final'
  end

  factory :inspection_type_residential, class: InspectionType do
    inspection_supercategory 'residential'
    inspection_supercategory_name 'Single-family / Duplex'
    inspection_category 'roof'
    inspection_category_name 'Roof'
    inspection_name 'Final'
  end
end
