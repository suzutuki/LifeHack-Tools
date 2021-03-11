# == Schema Information
#
# Table name: steps
#
#  id         :bigint           not null, primary key
#  day        :date
#  done       :boolean
#  goal       :string(255)
#  name       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :integer
#  user_id    :bigint
#
# Indexes
#
#  index_steps_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class StepTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
