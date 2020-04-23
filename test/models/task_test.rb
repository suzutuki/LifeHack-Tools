require 'test_helper'

class TaskTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @task = @user.tasks.build(content: "Lorem ipsum",title: "test10")
  end

  # test "should be valid" do
  #   assert @task.valid?
  # end

  # test "user id should be present" do
  #   @task.user_id = nil
  #   assert_not @task.valid?
  # end
  
  test "order should be most recent first" do
    assert_equal tasks(:most_recent), Task.first
  end
end