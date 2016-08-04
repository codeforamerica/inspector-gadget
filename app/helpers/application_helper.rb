module ApplicationHelper
  # This should show the last day that could have had scheduled inspections
  # (i.e. not a weekend or holiday)
  # Is based on *calendar* day, not business day
  # So a little logic is required outside of business hours
  def last_inspection_day_date
    if !Date.today.weekday?
      return 0.business_day.ago.to_date
    elsif Time.zone.now < BusinessTime::Config.beginning_of_workday.in_time_zone.to_time
      return 0.business_day.ago.to_date
    elsif Time.zone.now > BusinessTime::Config.end_of_workday.in_time_zone.to_time
      return 1.business_day.ago.to_date # I have no idea why this is right, but it has tests :-)
    else # during business hours
      return 1.business_day.ago.to_date
    end
  end

  def next_inspection_day_date
    if Time.zone.now < BusinessTime::Config.beginning_of_workday.in_time_zone.to_time
      return 1.business_day.from_now.to_date
    elsif Time.zone.now > BusinessTime::Config.end_of_workday.in_time_zone.to_time
      return 0.business_day.from_now.to_date
    else # during business hours
      return 1.business_day.from_now.to_date
    end
  end

  def get_monthly_reporting_start_date
    return Date.today - 1.month
  end

  def get_monthly_reporting_end_date
    return 2.business_days.from_now.to_date
  end

  def inspections_by_day
    start_date = get_monthly_reporting_start_date
    end_date = get_monthly_reporting_end_date
    requested_for_date_query = Inspection.where("requested_for_date > ? and requested_for_date < ?", start_date, end_date)
    return requested_for_date_query.group_by_day(:requested_for_date).count
  end

end
