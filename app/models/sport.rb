# == Schema Information
#
# Table name: sports
#
#  id         :bigint           not null, primary key
#  end_on     :float(24)
#  sport_day  :date
#  sport_time :float(24)
#  start_on   :float(24)
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
class Sport < ApplicationRecord
  belongs_to :user
end
