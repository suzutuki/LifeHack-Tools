class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # 画像サイズを取得するためにRMagick使用
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick


  # このアップローダで使用するストレージの種類を選択します。
  # developmentとtest以外はS3を使用
  if Rails.env.development? || Rails.env.test?
    storage :file
  else
    storage :fog
  end

  # 画像の上限を640x480にする
  process :resize_to_limit => [640, 480]

  # サムネイルを生成する設定
  version :thumb100 do
    process :resize_to_limit => [100, 100]
  end

  version :thumb30 do
    process :resize_to_limit => [30, 30]
  end

  # アップロードされたファイルが保存されるディレクトリを上書きします。
  # これは、マウントされることを前提としたアップローダのための、賢明なデフォルトです。
  # 画像ごとに保存するディレクトリを変える
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # 許可する画像の拡張子
  def extension_allowlist
    %w(jpg jpeg gif png)
  end

  def filename
    "#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.#{file.extension}" if original_filename
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

  # アップロードされるファイルのファイル名を変更します。
  # 詳細は uploader/store.rb を参照してください。
  # def filename
  #   "something.jpg" if original_filename
  # end
end
