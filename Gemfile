source 'https://rubygems.org'
ruby '2.3.0'


gem 'rails', '4.2.6'
gem 'rails_12factor'
gem 'newrelic_rpm'

gem 'puma'

gem 'pg'
gem 'activerecord-postgis-adapter'
gem 'rgeo-shapefile'

gem 'sass-rails', '~> 5.0'
gem 'foundation-rails'

gem 'haml-rails'

gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'jquery-ui-sass-rails'
gem 'lodash-rails'

gem 'compass-rails' # chosen-rails 1.5.1 seems to have this as an undeclared dependency
gem 'chosen-rails', '1.5.1'

gem 'groupdate'
gem 'chartkick'

gem 'business_time'

gem 'rubyzip'

gem 'geocoder'
gem 'rgeo-geojson'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'capybara-webkit'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'codeclimate-test-reporter', require: false
end
