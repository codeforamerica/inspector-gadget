class Api::V1::InspectionTypesController < ApplicationController

  def get
    respond_to do |f|
      f.json do
        filters = {}
        filters.merge!({ inspection_supercategory: params[:supercategory] }) if params[:supercategory].present?
        filters.merge!({ inspection_category: params[:category] }) if params[:category].present?

        inspection_types = InspectionType.where(filters).select(:inspection_category, :inspection_name)

        render json: inspection_types.to_json
      end
    end
  end

  private

    # Only allow a trusted parameter "white list" through.
    def inspection_params
      params.permit(:supercategory, :category)
    end

end
