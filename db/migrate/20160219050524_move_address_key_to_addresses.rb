class MoveAddressKeyToAddresses < ActiveRecord::Migration[5.0]
  def change
    remove_column :inspections, :address_id, :integer
    add_column :addresses, :inspection_id, :integer
  end
end
