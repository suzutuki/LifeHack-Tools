source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.3'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass', '3.3.7'
gem 'font-awesome-sass'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'bcrypt', '~> 3.1.7'
gem 'kaminari'
gem 'rails-i18n', '~> 5.1'
gem 'jbuilder', '~> 2.5'
gem 'chart-js-rails', '~> 0.1.4'
gem 'gon', '~> 6.2.0'
# gem 'redis', '~> 4.0'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'jquery-rails', '~>4.3.1'
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'mysql2'
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
end

group :test do
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest',                 '5.10.3'
  gem 'minitest-reporters',       '1.1.14'
  gem 'guard',                    '2.16.2'
  gem 'guard-minitest',           '2.4.4'
end
group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'pry-byebug'
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
end
group :production do
end