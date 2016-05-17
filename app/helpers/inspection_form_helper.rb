module InspectionFormHelper
  def min_days_from_now
    Time.zone.now.hour <= 15 ? 1 : 2 # cutoff to schedule next-day inspections is 3pm
  end
end
