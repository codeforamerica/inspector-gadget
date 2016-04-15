require 'rails_helper'

describe InspectionsController do
  it '#show should return 200 for a valid inspection' do
    get :show, id: Inspection.take.id
    expect(response.response_code).to eq(200)
  end

end
