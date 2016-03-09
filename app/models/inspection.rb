class Inspection < ActiveRecord::Base
  has_one :address
  belongs_to :inspection_type
  has_many :assignments
  has_many :inspectors, through: :assignments
  accepts_nested_attributes_for :address

  validates :inspection_type_id, presence: true

  scope :residential, -> { joins(:inspection_type).where(inspection_types: {inspection_supercategory: 'residential'}) }
  scope :commercial, -> { joins(:inspection_type).where(inspection_types: {inspection_supercategory: 'residential'}) }

  def current_assignment
    self.assignments.first || nil
  end

  def inspector
    Inspector.joins(:inspector_profile)
      .where(inspector_profiles: {inspector_type: self.inspection_type.inspection_supercategory})
      .where("ST_Covers(inspector_profiles.inspection_region, ?)", self.address.geo_location)
      .first
  end
end
