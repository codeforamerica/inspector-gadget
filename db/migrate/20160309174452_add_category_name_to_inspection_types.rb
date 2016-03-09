class AddCategoryNameToInspectionTypes < ActiveRecord::Migration
  def change
    add_column :inspection_types, :inspection_category_name, :string
  end
end
