class CreateAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :assignments do |t|
      t.integer :inspector_id
      t.integer :inspection_id
      t.datetime :scheduled_for

      t.timestamps
    end

    rename_column :inspections, :scheduled_for, :requested_for
  end
end
