BusinessTime::Config.load("#{Rails.root}/config/business_time.yml")

# or you can configure it manually:  look at me!  I'm Tim Ferriss!
BusinessTime::Config.beginning_of_workday = "8:00 am" # earliest morning inspection time
BusinessTime::Config.end_of_workday = "3:00 pm" # cutoff for inspections to be filed for next business day

observed_holidays = [
  "New Year's Day",
  "Martin Luther King, Jr. Day",
  "Presidents' Day",
  "Memorial Day",
  "Independence Day",
  "Labor Day",
  "Thanksgiving",
  "Christmas Day",
]

# as long as the application is restarted at least once every 5 years,
# this should be fine
Holidays.between(Date.current, Date.current+5.years, :us, :observed).select{|holiday| observed_holidays.include? holiday[:name]}.each do |holiday|
  BusinessTime::Config.holidays << holiday[:date]
end
