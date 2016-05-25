module ApplicationHelper
  # This should show the last day that could have had scheduled inspections
  # (i.e. not a weekend or holiday)
  # Is based on *calendar* day, not business day
  # So a little logic is required outside of business hours
  def last_inspection_day_date
    if !Date.today.weekday?
      return 0.business_day.ago.to_date
    elsif Time.zone.now < BusinessTime::Config.beginning_of_workday.to_time
      return 0.business_day.ago.to_date
    elsif Time.zone.now > BusinessTime::Config.end_of_workday.to_time
      return 1.business_day.ago.to_date # I have no idea why this is right, but it has tests :-)
    else # during business hours
      return 1.business_day.ago.to_date
    end
  end

  def next_inspection_day_date
    if Time.zone.now < BusinessTime::Config.beginning_of_workday.to_time 
      return 1.business_day.from_now.to_date
    elsif Time.zone.now > BusinessTime::Config.end_of_workday.to_time
      return 0.business_day.from_now.to_date
    else # during business hours
      return 1.business_day.from_now.to_date
    end
  end
end
