class InspectionType < ActiveRecord::Base
  has_many :inspections

  def to_s
    [self.inspection_supercategory.titleize, self.inspection_category.titleize, self.inspection_name.titleize].join(' - ')
  end
end
