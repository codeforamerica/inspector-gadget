require 'test_helper'

class InspectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inspection = inspections(:one)
  end

  test "should get index" do
    get inspections_url
    assert_response :success
  end

  test "should get new" do
    get new_inspection_url
    assert_response :success
  end

  test "should create inspection" do
    assert_difference('Inspection.count') do
      post inspections_url, params: { inspection: { address_id: @inspection.address_id, business_name: @inspection.business_name, contact_email: @inspection.contact_email, contact_name: @inspection.contact_name, contact_phone: @inspection.contact_phone, inspection_type: @inspection.inspection_type, scheduled_for: @inspection.scheduled_for } }
    end

    assert_redirected_to inspection_path(Inspection.last)
  end

  test "should show inspection" do
    get inspection_url(@inspection)
    assert_response :success
  end

  test "should get edit" do
    get edit_inspection_url(@inspection)
    assert_response :success
  end

  test "should update inspection" do
    patch inspection_url(@inspection), params: { inspection: { address_id: @inspection.address_id, business_name: @inspection.business_name, contact_email: @inspection.contact_email, contact_name: @inspection.contact_name, contact_phone: @inspection.contact_phone, inspection_type: @inspection.inspection_type, scheduled_for: @inspection.scheduled_for } }
    assert_redirected_to inspection_path(@inspection)
  end

  test "should destroy inspection" do
    assert_difference('Inspection.count', -1) do
      delete inspection_url(@inspection)
    end

    assert_redirected_to inspections_path
  end
end
