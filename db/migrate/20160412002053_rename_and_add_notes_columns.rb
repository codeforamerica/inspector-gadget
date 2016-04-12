class RenameAndAddNotesColumns < ActiveRecord::Migration
  def change
    rename_column :inspections, :notes, :address_notes
    add_column :inspections, :inspection_notes, :string
  end
end
