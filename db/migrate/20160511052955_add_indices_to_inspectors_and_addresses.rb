class AddIndicesToInspectorsAndAddresses < ActiveRecord::Migration
  def change
    add_index :addresses, :inspection_id
    add_index :inspector_profiles, :inspector_id
  end
end
