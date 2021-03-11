require 'test_helper'

class ItsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get its_create_url
    assert_response :success
  end

  test "should get destroy" do
    get its_destroy_url
    assert_response :success
  end

  test "should get show" do
    get its_show_url
    assert_response :success
  end

  test "should get details" do
    get its_details_url
    assert_response :success
  end

  test "should get new" do
    get its_new_url
    assert_response :success
  end

end
