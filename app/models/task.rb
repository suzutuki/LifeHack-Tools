class Task < ApplicationRecord
  belongs_to :user
  default_scope -> { order(priority: :asc) }
  validates :priority, numericality: {message: '数値を入力してください！'},
            uniqueness: {message: 'すでに設定したリストと優先順位がかぶっています'}
  validates :title, presence: {message: 'タイトルを入力してください'},
            length: {minimum: 2, message: '2文字以上で入力してください'}
  validates :content, length: {maximum: 50, message: '50文字まで登録できます。'}

end
