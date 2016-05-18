module InspectionFormHelper
  def next_available_date
    next_available = 1.business_day.after(0.business_hours.from_now)
    next_available.to_date
  end
end
