source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '3.0.4'

gem 'rails', '~> 7.0.8', '>= 7.0.8.4'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]
gem 'bootsnap', require: false
gem 'active_model_serializers'
gem "interactor"
gem 'dry-validation', '~> 1.10'
gem 'will_paginate'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
  gem 'byebug'
  gem 'rspec-rails', '~> 7.0.0'
  gem "factory_bot_rails"
  gem "faker"
end

group :test do
  gem 'database_cleaner-active_record'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem 'spring'
end
