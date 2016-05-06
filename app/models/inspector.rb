class Inspector < User
  has_one :inspector_profile
  delegate :inspection_types, to: :inspector_profile
  delegate :inspection_assignments, to: :inspector_profile

  scope :residential, -> { joins(:inspection_profile).where(inspector_type: 'residential') }
  scope :commercial, -> { joins(:inspection_profile).where(inspector_type: 'commercial') }
end
