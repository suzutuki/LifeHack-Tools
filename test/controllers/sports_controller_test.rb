require 'test_helper'

class SportsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get sports_create_url
    assert_response :success
  end

  test "should get destroy" do
    get sports_destroy_url
    assert_response :success
  end

  test "should get index" do
    get sports_index_url
    assert_response :success
  end

  test "should get edit" do
    get sports_edit_url
    assert_response :success
  end

  test "should get show" do
    get sports_show_url
    assert_response :success
  end

  test "should get new" do
    get sports_new_url
    assert_response :success
  end

end
