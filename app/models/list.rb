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
class List < ApplicationRecord
  belongs_to :user
  validates :question, length: {maximum: 65535}
  validates :answer, length: {maximum: 65535}
  enum rate: {important: 1, good: 2, normal: 3}
  validates :event, length: {maximum: 65535}
  validates :respect, length: {maximum: 65535}
  validates :disdain, length: {maximum: 65535}
  validates :boss, length: {maximum: 65535}
  validates :guidance, length: {maximum: 65535}
end
