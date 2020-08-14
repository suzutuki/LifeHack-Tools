# == Schema Information
#
# Table name: tasks
#
#  id         :bigint           not null, primary key
#  content    :text(65535)
#  done       :boolean
#  priority   :integer
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_tasks_on_user_id                 (user_id)
#  index_tasks_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
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
