# == Schema Information
#
# Table name: macs
#
#  id         :bigint           not null, primary key
#  actionable :text(65535)
#  competent  :text(65535)
#  measurable :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_macs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class MacTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
