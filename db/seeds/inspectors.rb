##### INSPECTORS

new_email = Devise.friendly_token.first(6)
new_password = Devise.friendly_token.first(12)
inspector = Inspector.find_by(name: 'Engler') ||
            Inspector.create(name: 'Engler', email: "#{new_email}@example.com", password: new_password, password_confirmation: new_password)
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'residential')
                .update_attributes(inspection_assignments: ['residential_general'])

new_email = Devise.friendly_token.first(6)
new_password = Devise.friendly_token.first(12)
inspector = Inspector.find_by(name: 'Lloyd') ||
            Inspector.create(name: 'Lloyd', email: "#{new_email}@example.com", password: new_password, password_confirmation: new_password)
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'residential')
                .update_attributes(inspection_assignments: ['residential_general'])

new_email = Devise.friendly_token.first(6)
new_password = Devise.friendly_token.first(12)
inspector = Inspector.find_by(name: 'Morey') ||
            Inspector.create(name: 'Morey', email: "#{new_email}@example.com", password: new_password, password_confirmation: new_password)
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'residential')
                .update_attributes(inspection_assignments: ['residential_general'])

new_email = Devise.friendly_token.first(6)
new_password = Devise.friendly_token.first(12)
inspector = Inspector.find_by(name: 'Ciarrelli') ||
            Inspector.create(name: 'Ciarrelli', email: "#{new_email}@example.com", password: new_password, password_confirmation: new_password)
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'residential')
                .update_attributes(inspection_assignments: ['residential_general'])

new_email = Devise.friendly_token.first(6)
new_password = Devise.friendly_token.first(12)
inspector = Inspector.find_by(name: 'Reza') ||
            Inspector.create(name: 'Reza', email: "#{new_email}@example.com", password: new_password, password_confirmation: new_password)
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'residential')
                .update_attributes(inspection_assignments: ['residential_general'])

new_email = Devise.friendly_token.first(6)
new_password = Devise.friendly_token.first(12)
inspector = Inspector.find_by(name: 'Flacks') ||
            Inspector.create(name: 'Flacks', email: "#{new_email}@example.com", password: new_password, password_confirmation: new_password)
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'residential')
                .update_attributes(inspection_assignments: ['residential_general'])

new_email = Devise.friendly_token.first(6)
new_password = Devise.friendly_token.first(12)
inspector = Inspector.find_by(name: 'Mann') ||
            Inspector.create(name: 'Mann', email: "#{new_email}@example.com", password: new_password, password_confirmation: new_password)
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'residential')
                .update_attributes(inspection_assignments: ['residential_general'])

new_email = Devise.friendly_token.first(6)
new_password = Devise.friendly_token.first(12)
inspector = Inspector.find_by(name: 'Aaker') ||
            Inspector.create(name: 'Aaker', email: "#{new_email}@example.com", password: new_password, password_confirmation: new_password)
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'residential')
                .update_attributes(inspection_assignments: ['photovoltaic'])

# ----------

new_email = Devise.friendly_token.first(6)
new_password = Devise.friendly_token.first(12)
inspector = Inspector.find_by(name: 'Ingram') ||
            Inspector.create(name: 'Ingram', email: "#{new_email}@example.com", password: new_password, password_confirmation: new_password)
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'commercial')
                .update_attributes(inspection_assignments: %w(electric sign)) # 'photovoltaic' for all areas

new_email = Devise.friendly_token.first(6)
new_password = Devise.friendly_token.first(12)
inspector = Inspector.find_by(name: 'Varnes') ||
            Inspector.create(name: 'Varnes', email: "#{new_email}@example.com", password: new_password, password_confirmation: new_password)
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'commercial')
                .update_attributes(inspection_assignments: ['electric'])

new_email = Devise.friendly_token.first(6)
new_password = Devise.friendly_token.first(12)
inspector = Inspector.find_by(name: 'Mechanical') ||
            Inspector.create(name: 'Mechanical', email: "#{new_email}@example.com", password: new_password, password_confirmation: new_password)
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'commercial')
                .update_attributes(inspection_assignments: ['mechanical'])

new_email = Devise.friendly_token.first(6)
new_password = Devise.friendly_token.first(12)
inspector = Inspector.find_by(name: 'Marquez') ||
            Inspector.create(name: 'Marquez', email: "#{new_email}@example.com", password: new_password, password_confirmation: new_password)
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'commercial')
                .update_attributes(inspection_assignments: ['building']) # roof, foundation, drywall

new_email = Devise.friendly_token.first(6)
new_password = Devise.friendly_token.first(12)
inspector = Inspector.find_by(name: 'Nicholls') ||
            Inspector.create(name: 'Nicholls', email: "#{new_email}@example.com", password: new_password, password_confirmation: new_password)
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'commercial')
                .update_attributes(inspection_assignments: ['building']) # roof, foundation, drywall

new_email = Devise.friendly_token.first(6)
new_password = Devise.friendly_token.first(12)
inspector = Inspector.find_by(name: 'Plumbing') ||
            Inspector.create(name: 'Plumbing', email: "#{new_email}@example.com", password: new_password, password_confirmation: new_password)
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'commercial')
                .update_attributes(inspection_assignments: ['plumbing'])

new_email = Devise.friendly_token.first(6)
new_password = Devise.friendly_token.first(12)
inspector = Inspector.find_by(name: 'Joe') ||
            Inspector.create(name: 'Joe', email: "#{new_email}@example.com", password: new_password, password_confirmation: new_password)
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'commercial')
                .update_attributes(inspection_assignments: ['fire'])

new_email = Devise.friendly_token.first(6)
new_password = Devise.friendly_token.first(12)
inspector = Inspector.find_by(name: 'PLANNING') ||
            Inspector.create(name: 'PLANNING', email: "#{new_email}@example.com", password: new_password, password_confirmation: new_password)
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'commercial')
                .update_attributes(inspection_assignments: ['planning'])
