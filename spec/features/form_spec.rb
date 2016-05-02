require 'rails_helper'

describe "submitting an inspection request form", :type => :feature do

  it "as a non-staff user" do
    type = create(:inspection_type) # fabricator should create a "Commercial" inspection type
    visit '/inspections/new'
    within("#new_inspection") do
      fill_in 'inspection_permit_number', :with => 'BRM1234'
      fill_in 'inspection_contact_email', :with => Faker::Internet.email
      fill_in 'inspection_contact_name', :with => Faker::Name.name
      fill_in 'inspection_contact_phone', :with => Faker::PhoneNumber.phone_number
      fill_in 'inspection_requested_for_date', :with => Date.tomorrow.strftime("%m/%d/%Y")
      select 'Morning 8-12pm', :from => 'inspection_requested_for_time'
      check('inspection_contact_phone_can_text')

      select("Commercial", :from => 'supercategory') # should reference inspection type created by fabricator above
      wait_for_ajax
      select("#{type.inspection_category_name}", :from => 'category')
      wait_for_ajax
      select("#{type.inspection_name}", :from => 'name', :match => :prefer_exact)
      
      # Google Places Autocomplete is *very* difficult to fake user interaction for
      page.execute_script("$('#street_number').val('333').removeAttr('disabled');")
      page.execute_script("$('#route').val('West Ocean Blvd').removeAttr('disabled');")
      page.execute_script("$('#locality').val('Long Beach').removeAttr('disabled');")
      page.execute_script("$('#administrative_area_level_1').val('CA').removeAttr('disabled');")
      page.execute_script("$('#postal_code').val('90802').removeAttr('disabled');")
    end
    click_button 'Submit'
    expect(page).to have_content 'Inspection was successfully created.'
  end

  it "as a staff user (express form)" do
    type = create(:inspection_type) # fabricator should create a "Commercial" inspection type
    visit '/inspections/new_express'
    within("#new_inspection") do
      fill_in 'inspection_permit_number', :with => 'BRM1234'
      fill_in 'inspection_contact_email', :with => Faker::Internet.email
      fill_in 'inspection_contact_name', :with => Faker::Name.name
      fill_in 'inspection_contact_phone', :with => Faker::PhoneNumber.phone_number
      fill_in 'inspection_requested_for_date', :with => Date.tomorrow.strftime("%m/%d/%Y")
      select 'Morning 8-12pm', :from => 'inspection_requested_for_time'
      check('inspection_contact_phone_can_text')

      choose("Commercial / Multifamily Residential / Condo") # should reference inspection type created by fabricator above
      wait_for_ajax
      chosen_select("#{type.inspection_name}", from: 'inspection_names')

      # Google Places Autocomplete is *very* difficult to fake user interaction for
      page.execute_script("$('#street_number').val('333').removeAttr('disabled');")
      page.execute_script("$('#route').val('West Ocean Blvd').removeAttr('disabled');")
      page.execute_script("$('#locality').val('Long Beach').removeAttr('disabled');")
      page.execute_script("$('#administrative_area_level_1').val('CA').removeAttr('disabled');")
      page.execute_script("$('#postal_code').val('90802').removeAttr('disabled');")
    end
    click_button 'Submit'
    expect(page).to have_content 'Inspection was successfully created.'
  end

end
