ActiveAdmin.register Inspection do

  permit_params :permit_number,
                :contact_name,
                :contact_phone,
                :contact_email,
                :requested_for_date,
                address_attributes: [
                  :street_number,
                  :route,
                  :city,
                  :state,
                  :zip,
                ]

  filter :requested_for_date

  index do
    selectable_column
    id_column
    column :contact_name
    column :contact_phone
    column :contact_email
    column :requested_for_date
    actions
  end

  show do
    attributes_table_for inspection do
      row :permit_number
      row :contact_name
      row :contact_phone
      row :contact_email
      row :requested_for_date
      row :requested_for_time
      row :created_at
      row :contact_phone_can_text
      row :inspection_notes
    end
    attributes_table_for inspection.address do
      row :city
      row :zip
    end
  end

  form do |f|
    f.inputs 'Inspection' do
      f.input :permit_number
      f.input :contact_name
      f.input :contact_phone
      f.input :contact_email
      f.input :requested_for_date
      f.input :requested_for_time
      f.input :contact_phone_can_text
      f.input :inspection_notes
    end

    f.inputs 'Address' do
      f.has_many :address do |a|
        a.input :street_number
        a.input :route
        a.input :city
        a.input :state
        a.input :zip
      end
    end
    f.actions
  end
end
