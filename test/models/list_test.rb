# == Schema Information
#
# Table name: lists
#
#  id         :bigint           not null, primary key
#  answer     :text(65535)
#  boss       :text(65535)
#  disdain    :text(65535)
#  done       :boolean
#  event      :text(65535)
#  guidance   :text(65535)
#  question   :text(65535)
#  respect    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_lists_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class ListTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
