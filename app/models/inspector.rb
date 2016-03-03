class Inspector < User
  has_one :inspector_profile

  delegate :inspection_categories, to: :inspector_profile
end
