class CreateInspectionTypes < ActiveRecord::Migration
  def change
    create_table :inspection_types do |t|
      t.string :inspection_category
      t.string :inspection_name
    end
  end
end
