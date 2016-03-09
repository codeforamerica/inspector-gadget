class AddCommentsToInspectionTypes < ActiveRecord::Migration
  def change
    add_column :inspection_types, :comments, :text
  end
end
