# Itのコレクションモデル
class ItCollection
#   persisted?メソッドとidメソッドの定義のため
  include ActiveModel::Conversion
#   命名やルーティングの管理を支援するクラスメソッドを多数追加
  extend ActiveModel::Naming
#   オブジェクトとRails国際化（i18n）フレームワーク間の統合機能を提供
  extend ActiveModel::Translation
#   クラスのメソッドにカスタムのプレフィックスやサフィックスを追加
  include ActiveModel::AttributeMethods
  #   クラスオブジェクトをActive Recordスタイルで検証できる。
  include ActiveModel::Validations
  attr_accessor :collection
  IT_NUM = 3 # 同時にitを作成する数

  # 初期化メソッド
  def initialize(current_user, attributes = [])
    if attributes.present?
      self.collection = attributes.map do |value|
        It.new(
          user_id: current_user.id,
          situation: value['situation'],
          behavior: value['behavior']
        )
      end
    else
      self.collection = IT_NUM.times.map { It.new }
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
