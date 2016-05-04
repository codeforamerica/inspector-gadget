##### INSPECTORS

inspector = Inspector.find_or_create_by(name: "Engler")
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'residential').update_attributes(inspection_assignments: ['residential_general'])

inspector = Inspector.find_or_create_by(name: "Lloyd")
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'residential').update_attributes(inspection_assignments: ['residential_general'])

inspector = Inspector.find_or_create_by(name: "Morey")
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'residential').update_attributes(inspection_assignments: ['residential_general'])

inspector = Inspector.find_or_create_by(name: "Ciarrelli")
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'residential').update_attributes(inspection_assignments: ['residential_general'])

inspector = Inspector.find_or_create_by(name: "Reza")
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'residential').update_attributes(inspection_assignments: ['residential_general'])

inspector = Inspector.find_or_create_by(name: "Flacks")
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'residential').update_attributes(inspection_assignments: ['residential_general'])

inspector = Inspector.find_or_create_by(name: "Mann")
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'residential').update_attributes(inspection_assignments: ['residential_general'])

inspector = Inspector.find_or_create_by(name: "Aaker")
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'residential').update_attributes(inspection_assignments: ['photovoltaic'])

# ----------

inspector = Inspector.find_or_create_by(name: "Ingram")
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'commercial').update_attributes(inspection_assignments: ['electric', 'sign']) #'photovoltaic' for all areas

inspector = Inspector.find_or_create_by(name: "Varnes")
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'commercial').update_attributes(inspection_assignments: ['electric'])

inspector = Inspector.find_or_create_by(name: "Mechanical")
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'commercial').update_attributes(inspection_assignments: ['mechanical'])

inspector = Inspector.find_or_create_by(name: "Marquez")
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'commercial').update_attributes(inspection_assignments: ['building']) # roof, foundation, drywall

inspector = Inspector.find_or_create_by(name: "Nicholls")
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'commercial').update_attributes(inspection_assignments: ['building']) # roof, foundation, drywall

inspector = Inspector.find_or_create_by(name: "Plumbing")
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'commercial').update_attributes(inspection_assignments: ['plumbing'])

inspector = Inspector.find_or_create_by(name: "Joe")
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'commercial').update_attributes(inspection_assignments: ['fire'])

inspector = Inspector.find_or_create_by(name: "PLANNING")
InspectorProfile.find_or_create_by(inspector_id: inspector.id, inspector_type: 'commercial').update_attributes(inspection_assignments: ['planning'])
