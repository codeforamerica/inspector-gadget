class Inspection < ActiveRecord::Base
  has_one :address
  belongs_to :inspection_type
  accepts_nested_attributes_for :address

  phony_normalize :contact_phone, default_country_code: 'US'

  validates :inspection_type_id, presence: true

  scope :residential, -> { joins(:inspection_type).where(inspection_types: {inspection_supercategory: 'residential'}) }
  scope :commercial, -> { joins(:inspection_type).where(inspection_types: {inspection_supercategory: 'commercial'}) }

  delegate :possible_inspectors, to: :inspection_type

  def inspector
    inspectors = self.possible_inspectors # list of inspectors that handle this inspection *type*

    if inspectors.count > 1
      # of the possible inspectors, find which one handles this inspection *location*
      inspector = inspectors.joins(:inspector_profile)
        .where("ST_IsEmpty(inspector_profiles.inspection_region::geometry) = false") # hack to check if inspection_region is present - AR says some records are `nil` even when geo data is present
        .where("ST_Covers(inspector_profiles.inspection_region, ?)", self.address.try(:geo_location))
        .first
    else
      inspector = inspectors.first
    end

    inspector
  end
end
