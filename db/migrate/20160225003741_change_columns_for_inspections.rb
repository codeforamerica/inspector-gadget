class ChangeColumnsForInspections < ActiveRecord::Migration
  def change
    add_column :inspections, :permit_number, :string
    add_column :inspections, :property_type, :string
    remove_column :inspections, :business_name
    rename_column :inspections, :requested_for, :requested_for_date
    add_column :inspections, :requested_for_time, :string
    add_column :inspections, :notes, :text
  end
end
