class Inspection < ActiveRecord::Base
  has_one :address
  has_one :inspection_type
  has_many :assignments
  has_many :inspectors, through: :assignments
  accepts_nested_attributes_for :address

  def current_assignment
    self.assignments.first || nil
  end
end
