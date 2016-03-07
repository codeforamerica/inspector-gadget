class Address < ActiveRecord::Base
  belongs_to :inspection
  after_validation :geocode
  geocoded_by :to_s do |record, results|
    result = results.first
    record.geo_location = RGeo::Geographic.spherical_factory(srid: 4326).point(result.longitude, result.latitude) if result.present?
  end

  def to_s
    [
      (line_1 + (line_2 || '')),
      city,
      state,
      zip,
    ].join(', ')
  end
end
