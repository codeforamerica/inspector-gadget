class InspectionsController < ApplicationController
  before_action :allow_iframing, only: [:confirmation, :new]
  protect_from_forgery except: :create

  def print
    inspections = Inspection.where("date_trunc('day', requested_for_date) = ?", params[:date])
    inspection_objs = inspections.map do |inspection|
      inspection.attributes.tap do |i|
        i["requested_for_date"] = inspection.requested_for_date.to_date
        i["contact_phone"] = inspection.contact_phone.phony_formatted(normalize: :US)
        i['created_at'] = inspection.created_at.strftime('%b %e, %l:%M %p %Z')
        i['inspection_type'] = inspection.inspection_type.to_s
        i['address'] = inspection.address.to_s
        i["inspector"] = inspection.inspector.try(:name) || ''
        i["inspection_supercategory"] = inspection.inspection_type.inspection_supercategory
      end
    end
    inspection_objs.sort_by! {|i| i['inspector'] }
    residential_inspections = inspection_objs.select{|i| i['inspection_supercategory'] == 'residential'}
    commercial_inspections = inspection_objs.select{|i| i['inspection_supercategory'] == 'commercial'}
    @inspection_cards = group_inspections(residential_inspections) + commercial_inspections
    render layout: 'print'
  end

  def confirmation
    @inspections = Inspection.where(id: params[:inspection_ids].split(',')) # 1,2 => [1,2]

    if params[:express] == 'true'
      render :confirmation_express
    else
      render :confirmation
    end
  end

  # GET /inspections/new
  def new # customer-facing form
    @inspection = Inspection.new
    @inspection.build_address # Rails needs the associated Address model to exist in order to render form
  end

  def new_express # staff-facing form, with different layout based on their prefs
    @inspection = Inspection.new
    @inspection.build_address # Rails needs the associated Address model to exist in order to render form
  end

  # POST /inspections
  def create
    # Form is sufficiently complex that handling the data
    # was worth pulling into a separate module, `InspectionForm`.
    # This does stuff like making one Inspection for each `inspection_type_id`
    # and running a bunch of validations.
    form = InspectionForm.new(inspection_params)

    if form.save
      if URI(request.referer).path == '/inspections/new_express'
        # send staff to the staff-facing confirmation page (note 'express' param)...
        redirect_to inspections_confirmation_path(inspection_ids: form.inspections.map(&:id).join(','), express: true), notice: 'Inspection was successfully created.'
      else
        # ...and everyone else to the normal confirmation page
        redirect_to inspections_confirmation_path(inspection_ids: form.inspections.map(&:id).join(',')), notice: 'Inspection was successfully created.'
      end
    else
      render :new
    end
  end

  private

  def group_inspections(inspections)
    groups = inspections.group_by{|i| [i['requested_for_date'],i['address'],i['created_at']] }
    consolidated_groups = groups.map do |group|
      base_inspection = group[1][0]
      base_inspection['inspection_types'] = group[1].map{|i| i['inspection_type']}
      base_inspection
    end

    consolidated_groups
  end

  # Only allow a trusted parameter "white list" through.
  def inspection_params
    params.require(:inspection).permit(
      :id,
      :permit_number,
      :contact_name,
      :contact_phone,
      :contact_phone_can_text,
      :contact_email,
      :inspection_type_id,
      :inspection_notes,
      :requested_for_date,
      :requested_for_time,
      :address_notes,
      address_attributes: [:street_number, :route, :city, :state, :zip]
    ).tap do |whitelisted|
      whitelisted[:requested_for_date] = Date.strptime(params['inspection']['requested_for_date'], '%m/%d/%Y')
    end
  end

  def allow_iframing
    response.headers.delete 'X-Frame-Options'
  end
end
