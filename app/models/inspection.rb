class Inspection < ActiveRecord::Base
  has_one :address
  belongs_to :inspection_type
  accepts_nested_attributes_for :address

  validates :inspection_type_id, presence: true

  scope :residential, -> { joins(:inspection_type).where(inspection_types: {inspection_supercategory: 'residential'}) }
  scope :commercial, -> { joins(:inspection_type).where(inspection_types: {inspection_supercategory: 'residential'}) }

  def inspector
    supercategory = self.inspection_type.inspection_supercategory
    if supercategory == 'residential'
      Inspector.joins(:inspector_profile)
        .where('ST_IsEmpty(inspector_profiles.inspection_region::geometry) = false') # terrible hack to check if inspection_region is present
        .where(inspector_profiles: {inspector_type: supercategory})
        .where("ST_Covers(inspector_profiles.inspection_region, ?)", self.address.try(:geo_location))
        .first
    elsif supercategory == 'commercial'
      Inspector.joins(:inspector_profile)
        .where('ST_IsEmpty(inspector_profiles.inspection_region::geometry) = false') # terrible hack to check if inspection_region is present
        .where(inspector_profiles: {inspector_type: supercategory})
        .where("inspector_profiles.inspection_categories @> ARRAY[?]::text[]", self.inspection_type.inspection_category)
        .where("ST_Covers(inspector_profiles.inspection_region, ?)", self.address.try(:geo_location))
        .first
    end
  end
end
