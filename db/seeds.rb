# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Inspectors
User.create(name: "Dale Wiersma", email: "dale@longbeach.gov", role: "inspector")
User.create(name: "Steven Valdez", email: "steven@longbeach.gov", role: "inspector")

# Test users
User.create(name: "Mark Rossetti", email: "markrossetti@codeforamerica.org", role: "requester")
User.create(name: "Patrick McDonnell", email: "patrick@codeforamerica.org", role: "requester")
User.create(name: "Lisa Ratner", email: "lisa@codeforamerica.org", role: "requester")



Inspection.create(
  business_name: "Mark's Tacos", 
  inspection_type: "fire",
  requested_for: Date.tomorrow,
  address: Address.create(line_1: "1234 Example Lane", city: "Long Beach", zip: '12345')
)

Inspection.create(
  business_name: "Mark's Tacos", 
  inspection_type: "health",
  requested_for: Date.tomorrow,
  address: Address.create(line_1: "1234 Example Lane", city: "Long Beach", zip: '12345')
)
