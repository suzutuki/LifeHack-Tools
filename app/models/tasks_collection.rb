# Taskのコレクションモデル
class TaskCollection
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  attr_accessor :collection
  TASK_NUM = 3 # 同時にtaskを作成する数

  # 初期化メソッド
  def initialize(current_user, attributes = [])
    if attributes.present?
      self.collection = attributes.map do |value|
        Task.new(
          user_id: current_user.id,
          content: value['content'],
          title: value['title'],
          priority: value['priority']
        )
      end
    else
      self.collection = TASK_NUM.times.map { Task.new }
    end
  end

  # レコードが存在するか確認するメソッド
  def persisted?
    false
  end

  # コレクションをDBに保存するメソッド
  def save
    is_success = true
    ActiveRecord::Base.transaction do
      collection.each do |result|
        # バリデーションを全てかけたいからsave!ではなくsaveを使用
        is_success = false unless result.save
      end
      # バリデーションエラーがあった時は例外を発生させてロールバックさせる
      raise ActiveRecord::RecordInvalid unless is_success
    end
  rescue
    p 'エラー'
  ensure
    return is_success
  end
end