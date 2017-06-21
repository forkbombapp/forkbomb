source 'https://rubygems.org'

ruby "2.1.4"
#ruby-gemset=forkbomb

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.0.2'

gem 'dotenv-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 3.2.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.6'

gem "github_api", '~> 0.17'

gem 'bootstrap-sass', '~> 3.0.3'
gem 'font-awesome-rails', '~> 4.7.0'
gem 'bootstrap-switch-rails', '~> 1.9.0'
gem 'kramdown'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'travis'
end

group :development, :test do
  gem 'sqlite3'
  gem 'webmock'
  gem 'vcr'
  gem 'rspec-rails'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'coveralls', require: false
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'guard-cucumber'
  gem 'timecop'
  gem 'poltergeist'
  gem 'factory_girl_rails'
end

# heroku gems
group :production do
  gem 'pg'
  gem 'rails_12factor'
end

gem 'devise'
gem 'omniauth'
gem 'omniauth-github'
gem 'delayed_job_active_record'
gem 'rack-google-analytics'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
