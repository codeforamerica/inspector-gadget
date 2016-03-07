class ChangeInspectionRegionToMultiPolygon < ActiveRecord::Migration
  def change
    remove_column :inspector_profiles, :inspection_region
    add_column :inspector_profiles, :inspection_region, :multi_polygon, geographic: true
  end
end
