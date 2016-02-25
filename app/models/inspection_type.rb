class InspectionType < ActiveRecord::Base
  def to_s
    [self.inspection_category.titleize, self.inspection_name.titleize].join(' - ')
  end
end
