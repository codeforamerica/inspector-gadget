class AddContactPhoneCanTextToInspections < ActiveRecord::Migration
  def change
    add_column :inspections, :contact_phone_can_text, :boolean, default: false
  end
end
