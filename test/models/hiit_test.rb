# == Schema Information
#
# Table name: hiits
#
#  id            :bigint           not null, primary key
#  content       :text(65535)
#  training_day  :date
#  training_time :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint
#
# Indexes
#
#  index_hiits_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class HiitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
