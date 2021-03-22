# == Schema Information
#
# Table name: sports
#
#  id         :bigint           not null, primary key
#  sport_day  :date
#  sport_time :float(24)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_sports_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class SportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
