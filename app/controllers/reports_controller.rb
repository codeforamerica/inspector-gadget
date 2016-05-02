class ReportsController < ApplicationController

  def daily
    @report_date = params[:report_date]
    @inspections = Inspection.where("date_trunc('day', requested_for_date) = ?", params[:report_date])
    @inspection_assignments = @inspections.group_by do |inspection|
      inspection.inspector
    end
  end

  def period
  end

end
