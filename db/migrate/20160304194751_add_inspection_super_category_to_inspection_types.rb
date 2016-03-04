class AddInspectionSuperCategoryToInspectionTypes < ActiveRecord::Migration
  def change
    add_column :inspection_types, :inspection_supercategory, :string
  end
end
