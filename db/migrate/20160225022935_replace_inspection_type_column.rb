class ReplaceInspectionTypeColumn < ActiveRecord::Migration
  def change
    remove_column :inspections, :inspection_type
    add_column :inspections, :inspection_type_id, :integer
  end
end
