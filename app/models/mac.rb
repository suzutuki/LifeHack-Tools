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
class Mac < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :asc) }
  validates :measurable, presence: {message: '目標を入力してください
  右上の?に例があるのでチェックして見てください。'}, length: { maximum: 1000}
  validates :actionable, presence: {message: 'ゴールまでのプロセスを入力してください。上部の？にヒントがあります。'}, length: { maximum: 1000}
  validates :competent, presence: {message: '自分の価値観に基づいているか入力してください。上部の？にヒントがあります。'}, length: { maximum: 1000}
end
