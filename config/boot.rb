ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

# Gemfile に記載されている gems をセットアップします。
require 'bundler/setup' 
