ActiveAdmin.register Inspection do

  index do
    selectable_column
    id_column
    column :contact_name
    column :contact_phone
    column :contact_email
    column :requested_for_date
    actions
  end

  filter :requested_for_date

end
