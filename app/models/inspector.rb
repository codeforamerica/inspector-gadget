class Inspector < User
  has_one :inspector_profile

  delegate :inspection_categories, to: :inspector_profile

  def inspections
    inspections = []
    if (profile = self.inspector_profile).present? && profile.inspection_region.present?
      if self.inspector_profile.inspector_type == 'residential'
        # residential inspections need *only* geo filter (no categories)
        inspections = Inspection.joins(:inspection_type).joins(:address)
          .where.not(addresses: {geo_location: nil})
          .where("ST_Covers(?, addresses.geo_location)", profile.inspection_region)
      elsif self.inspector_profile.inspector_type == 'commercial'
        # commercial inspections need both geo and category filters
        inspections = Inspection.joins(:inspection_type).joins(:address)
          .where(inspection_types: {inspection_supercategory: self.inspector_profile.inspector_type})
          .where(inspection_types: {inspection_category: self.inspection_categories})
          .where.not(addresses: {geo_location: nil})
          .where("ST_Covers(?, addresses.geo_location)", profile.inspection_region)
      end
    end
    inspections
  end
end
