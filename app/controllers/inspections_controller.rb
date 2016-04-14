class InspectionsController < ApplicationController
  before_action :set_inspection, only: [:show, :edit, :update, :destroy]
  before_action :allow_iframing, only: [:show, :new]

  # GET /inspections
  def index
    @inspections = Inspection.all
    @inspection_locations = Inspection.joins(:address)
      .where.not(addresses: { geo_location: nil } )
      .map{|i| [i.address.geo_location.y, i.address.geo_location.x]}
    @inspector_regions = Inspector.joins(:inspector_profile).map do |inspector|
      RGeo::GeoJSON.encode(inspector.inspector_profile.inspection_region).to_json
    end.reject!{|r| r == "null"}
  end

  def print
    @inspections = Inspection.where("date_trunc('day', requested_for_date) = ?", params[:date])
    render layout: 'print'
  end

  def report
    @report_date = params[:report_date]
    @inspections = Inspection.where("date_trunc('day', requested_for_date) = ?", params[:report_date])
    @inspection_assignments = @inspections.group_by do |inspection|
      inspection.inspector
    end
  end

  # GET /inspections/1
  def show
    if params[:express] == "true"
      render :show_express
    else
      render :show
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

  # GET /inspections/1/edit
  def edit
  end

  # POST /inspections
  def create
    @inspection = Inspection.new(inspection_params)
    @inspection.create_address(inspection_params[:address_attributes])

    if @inspection.save
      if URI(request.referer).path == '/inspections/new_express'
        redirect_to inspection_path(@inspection, express: true), notice: 'Inspection was successfully created.'
      else
        redirect_to @inspection, notice: 'Inspection was successfully created.'
      end
    else
      render :new
    end
  end

  # PATCH/PUT /inspections/1
  def update
    if @inspection.update(inspection_params)
      redirect_to @inspection, notice: 'Inspection was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /inspections/1
  def destroy
    @inspection.destroy
    redirect_to inspections_url, notice: 'Inspection was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inspection
      @inspection = Inspection.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def inspection_params
      params.require(:inspection).permit(:permit_number, :contact_name, :contact_phone, :contact_phone_can_text, :contact_email, :inspection_type_id, :inspection_notes, :requested_for_date, :requested_for_time, :address_notes,
        {address_attributes: [:street_number, :route, :city, :state, :zip]}
      ).tap do |whitelisted|
        whitelisted[:requested_for_date] = Date.strptime(params["inspection"]["requested_for_date"], '%m/%d/%Y')
      end
    end

    def allow_iframing
      response.headers.delete "X-Frame-Options"
    end
end
