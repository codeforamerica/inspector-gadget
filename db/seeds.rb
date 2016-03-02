#### INSPECTION TYPES
InspectionType.delete_all
[
  {category: 'building', name: 'footing' },
  {category: 'building', name: 'foundation' },
  {category: 'building', name: 'steel/rebar' },
  {category: 'building', name: 'framing' },
  {category: 'building', name: 'floor joist' },
  {category: 'building', name: 't-bar' },
  {category: 'building', name: 'insulation' },
  {category: 'building', name: 'drywall/nailing' },
  {category: 'building', name: 'lath/plaster' },
  {category: 'building', name: 'sandblast' },
  {category: 'building', name: 'windows' },
  {category: 'building', name: 'final' },
  {category: 'roof', name: 'shtg' },
  {category: 'roof', name: 'final' },
  {category: 'pool', name: 'pre-gunite' },
  {category: 'pool', name: 'gate/alarm' },
  {category: 'pool', name: 'final' },
  {category: 'mechanical', name: 'rough' },
  {category: 'mechanical', name: 'hoods/vent' },
  {category: 'mechanical', name: 'final' },
  {category: 'electric', name: 'temp pole' },
  {category: 'electric', name: 'ground work' },
  {category: 'electric', name: 'rough' },
  {category: 'electric', name: 'service upgrade' },
  {category: 'electric', name: 'photovoltaic' },
  {category: 'electric', name: 'sign' },
  {category: 'electric', name: 'car charger' },
  {category: 'electric', name: 'final' },
  {category: 'plumbing', name: 'ground work' },
  {category: 'plumbing', name: 'rough' },
  {category: 'plumbing', name: 'water heater' },
  {category: 'plumbing', name: 'repipe' },
  {category: 'plumbing', name: 'sewer' },
  {category: 'plumbing', name: 'shower pan' },
  {category: 'plumbing', name: 'hot mop' },
  {category: 'plumbing', name: 'gas test' },
  {category: 'plumbing', name: 'final' },
  {category: 'fire', name: 'alarm' },
  {category: 'fire', name: 'sprinkler' },
  {category: 'fire', name: 'hood/suppression' },
  {category: 'fire', name: 'final' },
].each do |it|
  InspectionType.create(inspection_category: it[:category], inspection_name: it[:name])
end


#### INSPECTIONS

Inspection.delete_all

# today
150.times do 
  Inspection.create(
    permit_number: '123456',
    contact_name: Faker::Name.name,
    contact_phone: Faker::PhoneNumber.phone_number,
    inspection_type: InspectionType.order('random()').take,
    requested_for_date: Date.today,
    requested_for_time: 'am',
    address: Address.create(line_1: "1234 Example Lane", city: "Long Beach", state: 'CA', zip: '12345'),
    notes: Faker::Lorem.sentence,
  )
end

# tomorrow
100.times do
  Inspection.create(
    permit_number: '123456',
    contact_name: Faker::Name.name,
    contact_phone: Faker::PhoneNumber.phone_number,
    inspection_type: InspectionType.order('random()').take,
    requested_for_date: Date.tomorrow,
    address: Address.create(line_1: "1234 Example Lane", city: "Long Beach", state: 'CA', zip: '12345'),
    notes: Faker::Lorem.sentence,
  )
end

# future
50.times do
  Inspection.create(
    permit_number: '123456',
    contact_name: Faker::Name.name,
    contact_phone: Faker::PhoneNumber.phone_number,
    inspection_type: InspectionType.order('random()').take,
    requested_for_date: Faker::Date.forward(30),
    address: Address.create(line_1: "1234 Example Lane", city: "Long Beach", state: 'CA', zip: '12345'),
    notes: Faker::Lorem.sentence,
  )
end


##### USERS

# Inspectors
# User.create(name: "Dale Wiersma", email: "dale@longbeach.gov", role: "inspector")
# User.create(name: "Steven Valdez", email: "steven@longbeach.gov", role: "inspector")

# Test users
# User.create(name: "Mark Rossetti", email: "markrossetti@codeforamerica.org", role: "requester")
# User.create(name: "Patrick McDonnell", email: "patrick@codeforamerica.org", role: "requester")
# User.create(name: "Lisa Ratner", email: "lisa@codeforamerica.org", role: "requester")
