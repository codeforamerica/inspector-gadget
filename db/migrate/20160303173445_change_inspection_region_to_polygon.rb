class ChangeInspectionRegionToPolygon < ActiveRecord::Migration
  def change
    remove_column :inspector_profiles, :inspection_region
    add_column :inspector_profiles, :inspection_region, :st_polygon, geographic: true
  end
end
