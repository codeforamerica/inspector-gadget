class InspectorProfile < ActiveRecord::Base
  belongs_to :inspector
  has_many :assignments
  has_many :inspection_types, through: :assignments
end
