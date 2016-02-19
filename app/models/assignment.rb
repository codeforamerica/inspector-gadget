class Assignment < ActiveRecord::Base
  belongs_to :inspection
  belongs_to :inspector, class_name: "User"
end
