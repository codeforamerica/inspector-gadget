class CreateInspections < ActiveRecord::Migration[5.0]
  def change
    create_table :inspections do |t|
      t.string :business_name
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_email
      t.string :inspection_type
      t.datetime :scheduled_for
      t.integer :address_id

      t.timestamps
    end
  end
end
