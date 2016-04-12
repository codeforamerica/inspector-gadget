class AddSupercategoryNameToInspectionType < ActiveRecord::Migration
  def change
    add_column :inspection_types, :inspection_supercategory_name, :string
  end
end
