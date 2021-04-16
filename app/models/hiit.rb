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
class Hiit < ApplicationRecord
  belongs_to :user
  default_scope -> { order(:training_day) }
  validates :training_day, presence:{ message: '運動した日を指定してください' }
  validates :training_time, numericality:
    { greater_than_or_equal_to: 0, less_than_or_equal_to: 1000,
      message: '運動時間は0以上1000分以下である必要があります' }
end
