class InspectionsController < ApplicationController
  before_action :allow_iframing, only: [:confirmation, :new]
  protect_from_forgery except: :create

  def print
    @inspections = Inspection.where("date_trunc('day', requested_for_date) = ?", params[:date])
    @inspections.to_a.sort_by! {|i| i.inspector.try(:name) || "" }
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
  def new
    @inspection = Inspection.new
    @inspection.build_address
  end

  def new_express
    @inspection = Inspection.new
    @inspection.build_address
  end

  # POST /inspections
  def create
    # create one Inspection for each `inspection_type_id` submitted
    form = InspectionForm.new(inspection_params)

    if form.save
      if URI(request.referer).path == '/inspections/new_express'
        redirect_to inspections_confirmation_path(inspection_ids: form.inspections.map(&:id).join(','), express: true), notice: 'Inspection was successfully created.'
      else
        redirect_to inspections_confirmation_path(inspection_ids: form.inspections.map(&:id).join(',')), notice: 'Inspection was successfully created.'
      end
    else
      render :new
    end
  end

  private

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
