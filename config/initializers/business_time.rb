BusinessTime::Config.load("#{Rails.root}/config/business_time.yml")

# or you can configure it manually:  look at me!  I'm Tim Ferriss!
BusinessTime::Config.beginning_of_workday = "8:00 am" # earliest morning inspection time
BusinessTime::Config.end_of_workday = "3:00 pm" # cutoff for inspections to be filed for next business day
#  BusinessTime::Config.holidays << Date.parse("August 4th, 2010")

