class Inspection < ActiveRecord::Base
  has_one :address
  belongs_to :inspection_type

  # makes it possible to assign things like inspection.street_number = '55'
  accepts_nested_attributes_for :address

  # standardizes phone numbers before saving (e.g. 5554567890 => +1-555-456-7890)
  phony_normalize :contact_phone, default_country_code: 'US'

  validates :inspection_type_id, presence: true

  # handy shortcuts that allow statements like `Inspection.residential`)
  # to get all inspetions of a certain type
  scope :residential, -> { joins(:inspection_type).where(inspection_types: {inspection_supercategory: 'residential'}) }
  scope :commercial, -> { joins(:inspection_type).where(inspection_types: {inspection_supercategory: 'commercial'}) }

  # `inspection.possible_inspectors` == `inspection.inspection_type.possible_inspectors`
  delegate :possible_inspectors, to: :inspection_type

  def inspector
    # get list of inspectors that handle this inspection *type*
    inspectors = self.possible_inspectors 

    if inspectors.count > 1
      # of the possible inspectors, find which one handles this inspection *location*
      inspector = inspectors.joins(:inspector_profile)
        .where("ST_IsEmpty(inspector_profiles.inspection_region::geometry) = false") # hack to check if inspection_region is present - AR says some records are `nil` even when geo data is present
        .where("ST_Covers(inspector_profiles.inspection_region, ?)", self.address.try(:geo_location))
        .first # `where` gives an array (though should be just one result), so `first` will get the item
    else
      inspector = inspectors.first
    end

    inspector
  end
end
