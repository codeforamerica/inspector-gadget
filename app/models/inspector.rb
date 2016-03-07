class Inspector < User
  has_one :inspector_profile

  delegate :inspection_categories, to: :inspector_profile

  def inspections
    if (profile = self.inspector_profile).present? && profile.inspection_region.present?
      Inspection.joins(:address)
        .where.not(addresses: {geo_location: nil})
        .where("ST_Covers(?, addresses.geo_location)", profile.inspection_region.to_s)
    else
      []
    end
  end
end
