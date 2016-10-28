# This model shares the `users` table via single-table inheritance (STI)
# This makes it easy for Inspectors to log in as Users in future, if desired
class Inspector < User
  # fields specific to an Inspector (i.e. not general to all Users) lives in the `inspector_profile`
  has_one :inspector_profile 
  
  delegate :inspection_types, to: :inspector_profile
  delegate :inspection_assignments, to: :inspector_profile

  scope :residential, -> { joins(:inspection_profile).where(inspector_type: 'residential') }
  scope :commercial, -> { joins(:inspection_profile).where(inspector_type: 'commercial') }
end
