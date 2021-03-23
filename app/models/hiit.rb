# == Schema Information
#
# Table name: hiits
#
#  id            :bigint           not null, primary key
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
class Hiit < ApplicationRecord
  belongs_to :user
end
