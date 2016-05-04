class RepurposeAssignments < ActiveRecord::Migration
  def change
    rename_column :assignments, :inspector_id, :inspector_profile_id
    rename_column :assignments, :inspection_id, :inspection_type_id
    remove_column :assignments, :scheduled_for, :datetime
    rename_column :inspector_profiles, :inspection_categories, :inspection_assignments
  end
end
