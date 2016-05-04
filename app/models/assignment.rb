class Assignment < ActiveRecord::Base
  belongs_to :inspector_profile
  belongs_to :inspection_type
end
