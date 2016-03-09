class InspectionsController < ApplicationController
  before_action :set_inspection, only: [:show, :edit, :update, :destroy]

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
    @inspections = Inspection.all
    render layout: 'print'
  end

  # GET /inspections/1
  def show
  end

  # GET /inspections/new
  def new
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
      redirect_to @inspection, notice: 'Inspection was successfully created.'
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
      params.require(:inspection).permit(:permit_number, :contact_name, :contact_phone, :contact_email, :inspection_type_id, :requested_for_date, :notes,
        {address_attributes: [:line_1, :line_2, :city, :state, :zip]}
      )
    end
end
