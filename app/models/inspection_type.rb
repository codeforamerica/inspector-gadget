class InspectionType < ActiveRecord::Base
  has_many :inspections
  has_many :assignments
  has_many :inspector_profiles, through: :assignments

  scope :residential, -> { where(inspection_supercategory: 'residential') }
  scope :commercial, -> { where(inspection_supercategory: 'commercial') }

  def possible_inspectors
    Inspector.where(id: self.inspector_profiles.pluck(:inspector_id) )
  end

  def to_s
    [self.inspection_supercategory.titleize, self.inspection_category.titleize, self.inspection_name.titleize].join(' - ')
  end
end
