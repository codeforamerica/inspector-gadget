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
    inspectors = self.possible_inspectors

    if inspectors.count > 1
      inspector = inspectors.joins(:inspector_profile)
        .where("ST_IsEmpty(inspector_profiles.inspection_region::geometry) = false") # terrible hack to check if inspection_region is present
        .where("ST_Covers(inspector_profiles.inspection_region, ?)", self.address.try(:geo_location))
        .first
    else
      inspector = inspectors.first
    end

    inspector
  end
end
