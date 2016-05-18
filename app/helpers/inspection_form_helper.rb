module InspectionFormHelper
  def next_available_date
    # advancing by 0.business_hours is a no-op during business hours
    # but advances time to the first business hour if executed during the night
    next_available = 1.business_day.after(0.business_hours.from_now)
    next_available.to_date
  end
end
