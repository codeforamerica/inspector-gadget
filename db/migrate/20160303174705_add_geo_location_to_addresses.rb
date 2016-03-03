class AddGeoLocationToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :geo_location, :st_point, geographic: true
  end
end
