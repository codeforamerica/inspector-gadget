##### USERS
User.delete_all

# Inspectors
Inspector.create(name: "Engler").create_inspector_profile(inspector_type: 'residential')
Inspector.create(name: "Lloyd").create_inspector_profile(inspector_type: 'residential')
Inspector.create(name: "Morey").create_inspector_profile(inspector_type: 'residential')
Inspector.create(name: "Ciarrelli").create_inspector_profile(inspector_type: 'residential')
Inspector.create(name: "Reza").create_inspector_profile(inspector_type: 'residential')
Inspector.create(name: "Flacks").create_inspector_profile(inspector_type: 'residential')
Inspector.create(name: "Mann").create_inspector_profile(inspector_type: 'residential')

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
