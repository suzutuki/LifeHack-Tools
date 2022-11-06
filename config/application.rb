require_relative 'boot'
require 'rails/all'

# Gemfile に記載されている gems を必要とする。
# :test, :development, :production のいずれかに限定したgemsを含む、Gemfileに記載されているgemsを必要とします。
Bundler.require(*Rails.groups)

module Todo
  class Application < Rails::Application
    # 元々生成されたRailsのバージョンに合わせた設定のデフォルトを初期化する。
    config.load_defaults 5.1
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml').to_s]
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
    config.action_controller.action_on_unpermitted_parameters = :raise
    # config/environments/* の設定は、ここで指定されたものよりも優先されます。
    # アプリケーションの設定は config/initializers にあるファイルに入れるべきです。
    # -- そのディレクトリにある全ての .rb ファイルが自動的にロードされます。
  end
end
