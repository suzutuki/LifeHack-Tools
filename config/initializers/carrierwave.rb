require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

# 画像名に日本語が使えるようにする
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

# 保存先の分岐
CarrierWave.configure do |config|
  # 本番環境はS3に保存
  if Rails.env.production?
    config.storage :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory = Rails.application.credentials.aws[:S3_bucket]
    config.fog_public = false
    config.asset_host = Rails.application.credentials.aws[:S3_asset_host]
    config.fog_credentials = {
      provider: 'AWS',
      # credentialsで管理する場合
      aws_access_key_id: Rails.application.credentials.aws[:access_key_id],
      aws_secret_access_key: Rails.application.credentials.aws[:secret_access_key],
      region: 'ap-northeast-1',
      path_style: true
    }
  
    # 本番環境以外の場合はアプリケーション内にアップロード
  else 
  config.storage :file
  config.enable_processing = false if Rails.env.test?
  end
end
