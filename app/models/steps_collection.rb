# Stepのコレクションモデル
class StepCollection
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  attr_accessor :collection
  STEP_NUM = 5 # 同時にstepを作成する数

  # 初期化メソッド
  def initialize(current_user, attributes = [])
    if attributes.present?
      self.collection = attributes.map do |value|
        Step.new(
          user_id: current_user.id,
          step_name: value['step_name']
        )
      end
    else
      self.collection = STEP_NUM.times.map { Step.new }
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