class CreateInspectorProfiles < ActiveRecord::Migration
  def change
    create_table :inspector_profiles do |t|
      t.integer :inspector_id
      t.string :inspector_type
      t.text :inspection_categories, array: true, default: []
      t.geometry :inspection_region, geographic: true

      t.timestamps null: false
    end
  end
end
