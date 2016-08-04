ActiveAdmin.register Inspection do
  permit_params :permit_number,
                :contact_name,
                :contact_phone,
                :contact_email,
                :requested_for_date,
                :requested_for_time,
                :contact_phone_can_text,
                :inspection_type,
                :inspection_notes,
                :address_notes,
                address_attributes: [
                  :street_number,
                  :route,
                  :city,
                  :state,
                  :zip
                ]

  filter :permit_number
  filter :requested_for_date

  index do
    selectable_column
    id_column
    column :permit_number do |i|
      if i.permit_number # should *always* be there, but just in case...
        i.permit_number.split('/').join(' ') # allows #s to split to multiple lines
      end
    end
    column :contact_name
    column 'Phone' do |i|
      i.contact_phone
    end
    column :inspection_type
    column :created_at do |i|
      i.created_at.strftime('%m-%d-%Y %H:%M %p %Z')
    end
    column 'Requested For' do |i|
      i.requested_for_date.strftime('%m-%d-%y')
    end
    column 'Address' do |i|
      # abbreviate Long Beach addresses
      # but show anything that's not LB, since that would be an error
      if i.address # should always exist, but just in case...
        if i.address.city == 'Long Beach' && i.address.state == 'CA'
          [i.address.street_number, i.address.route].join(' ')
        end
      end
    end
    column :inspector do |i|
      i.try(:inspector).try(:name)
    end
    actions
  end

  show do
    attributes_table do
      row :permit_number
      row :contact_name
      row :contact_phone
      row :contact_email
      row :requested_for_date do |i|
        i.requested_for_date.strftime('%m-%d-%y')
      end
      row :requested_for_time
      row :created_at do |i|
        i.created_at.strftime('%m-%d-%Y %H:%M %p %Z')
      end
      row :contact_phone_can_text
      row :inspection_type
      row :inspection_notes
      row :inspector do |i|
        i.try(:inspector).try(:name)
      end
      row :address
      row :address_notes
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
      f.input :inspection_type
      f.input :inspection_notes
      f.input :address_notes
    end
    f.inputs 'Address' do
      f.has_many :address, new_record: false do |a|
        a.input :street_number
        a.input :route
        a.input :city
        a.input :state
        a.input :zip
      end
    end
    f.actions
  end

  action_item :print_tomorrow, only: :index do
    link_to "Print Tomorrow's Inspections", inspections_print_path(date: next_inspection_day_date)
  end
end
