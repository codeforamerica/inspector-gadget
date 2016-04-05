class SplitAddressIntoTwoColumns < ActiveRecord::Migration
  def change
    remove_column :addresses, :line_1
    remove_column :addresses, :line_2
    add_column :addresses, :street_number, :string
    add_column :addresses, :route, :string
  end
end
