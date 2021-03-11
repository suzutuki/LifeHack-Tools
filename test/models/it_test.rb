# == Schema Information
#
# Table name: its
#
#  id         :bigint           not null, primary key
#  behavior   :text(65535)
#  situation  :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_its_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class ItTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
