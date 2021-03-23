require 'test_helper'

class HiitsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get hiits_create_url
    assert_response :success
  end

  test "should get destroy" do
    get hiits_destroy_url
    assert_response :success
  end

  test "should get new" do
    get hiits_new_url
    assert_response :success
  end

  test "should get edit" do
    get hiits_edit_url
    assert_response :success
  end

  test "should get show" do
    get hiits_show_url
    assert_response :success
  end

  test "should get index" do
    get hiits_index_url
    assert_response :success
  end

end
