BusinessTime::Config.load("#{Rails.root}/config/business_time.yml")

# or you can configure it manually:  look at me!  I'm Tim Ferriss!
BusinessTime::Config.beginning_of_workday = '8:00 am' # earliest morning inspection time
BusinessTime::Config.end_of_workday = '3:00 pm' # cutoff for inspections to be filed for next business day

observed_holidays = [
  "New Year's Day",
  "Martin Luther King, Jr. Day",
  "Presidents' Day",
  "Memorial Day",
  "Independence Day",
  "Labor Day",
  "Thanksgiving",
  "Christmas Day"
]

# this setting should be fine until the year 2100
Holidays.between(Date.new(2015), Date.new(2100), :us, :observed).select do |holiday| 
  observed_holidays.include? holiday[:name]
end.each do |holiday|
  BusinessTime::Config.holidays << holiday[:date]
end
