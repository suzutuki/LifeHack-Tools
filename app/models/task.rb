# == Schema Information
#
# Table name: tasks
#
#  id         :bigint           not null, primary key
#  content    :text(65535)
#  done       :boolean
#  priority   :integer
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_tasks_on_user_id                 (user_id)
#  index_tasks_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Task < ApplicationRecord
  belongs_to :user
  default_scope -> { order(:priority) }
  validates :title, presence: { message: 'タイトルを入力してください' },
            length: { minimum: 2, message: '2文字以上で入力してください' }
  validates :content, length: { maximum: 50, message: '登録できるのは50文字までです' }
  validates :priority, numericality: { message: '数値を入力してください！' }
end
