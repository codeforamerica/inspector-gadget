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
  {category: 'electric', name: 'sign' },
  {category: 'electric', name: 'car charger' },
  {category: 'electric', name: 'final' },
  {category: 'photovoltaic', name: 'photovoltaic' },
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
User.delete_all

# Inspectors
Inspector.create(name: "Engler", inspector_type: 'residential')
Inspector.create(name: "Lloyd", inspector_type: 'residential')
Inspector.create(name: "Morey", inspector_type: 'residential')
Inspector.create(name: "Ciarrelli", inspector_type: 'residential')
Inspector.create(name: "Reza", inspector_type: 'residential')
Inspector.create(name: "Flacks", inspector_type: 'residential')
Inspector.create(name: "Mann", inspector_type: 'residential')

Inspector.create(name: "Aaker").create_inspector_profile(inspector_type: 'commercial', inspection_categories: ['photovoltaic'])
Inspector.create(name: "Ingram").create_inspector_profile(inspector_type: 'commercial', inspection_categories: ['electric'])
Inspector.create(name: "Varnes").create_inspector_profile(inspector_type: 'commercial', inspection_categories: ['electric'])
Inspector.create(name: "Mechanical").create_inspector_profile(inspector_type: 'commercial', inspection_categories: ['mechanical'])
Inspector.create(name: "Marquez").create_inspector_profile(inspector_type: 'commercial', inspection_categories: ['building'])
Inspector.create(name: "Nicholls").create_inspector_profile(inspector_type: 'commercial', inspection_categories: ['building'])
Inspector.create(name: "Plumbing").create_inspector_profile(inspector_type: 'commercial', inspection_categories: ['plumbing'])
Inspector.create(name: "Joe").create_inspector_profile(inspector_type: 'commercial', inspection_categories: ['fire'])

# Customers
# Customer.create(name: "Mark Rossetti", email: "markrossetti@codeforamerica.org")
# Customer.create(name: "Patrick McDonnell", email: "patrick@codeforamerica.org")
# Customer.create(name: "Lisa Ratner", email: "lisa@codeforamerica.org")
