class Task < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :asc) }
  # validates :user_id, presence:true
  validates :title,   presence: { message: 'タイトルを入力してください!'},
             length: {minimum: 5, message: '5文字以上で入力してください！'}
  validates :content, length: {maximum: 50, message: '50文字まで登録できます。'}
end
