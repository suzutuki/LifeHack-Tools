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

  # アップロードされたファイルが保存されるディレクトリを上書きします。
  # これは、マウントされることを前提としたアップローダのための、賢明なデフォルトです。
  # 画像ごとに保存するディレクトリを変える
  # def store_dir
  #   "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  # end


  # 許可する画像の拡張子
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # ファイルがアップロードされていない場合には、デフォルトのURLを提供する。
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_allowlist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
