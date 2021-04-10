class ImageUploader < CarrierWave::Uploader::Base

  # 画像サイズを取得するためにRMagick使用
  include CarrierWave::RMagick

  # このアップローダで使用するストレージの種類を選択します。
  # developmentとtest以外はS3を使用
  if Rails.env.development? || Rails.env.test?
    storage :file
  else
    storage :fog
  end

  # アップロードされたファイルが保存されるディレクトリを上書きします。
  # これは、マウントされることを前提としたアップローダのための、賢明なデフォルトです。
  # 画像ごとに保存するディレクトリを変える
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # 許可する画像の拡張子
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def size_range
    1..5.megabytes
  end

  # 画像の上限を640x480にする
  process :resize_to_limit => [640, 480]

  # 保存形式をJPGにする
  process :convert => 'jpg'

  # サムネイルを生成する設定
  version :thumb do
    process :resize_to_limit => [400, 400]
  end

  version :thumb100 do
    process :resize_to_limit => [100, 100]
  end

  # 拡張子が同じでないとGIFをJPGとかにコンバートできないので、ファイル名を変更
  def filename
    super.chomp(File.extname(super)) + '.jpg' if original_filename.present?
  end

  # ファイル名を日付にするとタイミングのせいでサムネイル名がずれる
  #ファイル名はランダムで一意になる
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

  # ファイルがアップロードされていない場合には、デフォルトのURLを提供する。
  # def default_url(*args)
  # Rails 3.1+ のアセットパイプラインとの互換性のため。
  # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # アップロードされたファイルを処理します。
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # アップロードされたファイルの異なるバージョンを作成します。
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
