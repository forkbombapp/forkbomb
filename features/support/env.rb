require 'coveralls'
Coveralls.wear_merged!('rails')

require 'cucumber/rails'
require 'pry'
require 'vcr'
require 'webmock/cucumber'

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation

OmniAuth.config.test_mode = true

VCR.configure do |c|
  # Automatically filter all secure details that are stored in the environment
  ignore_env = %w{SHLVL RUNLEVEL GUARD_NOTIFY DRB COLUMNS USER LOGNAME LINES ITERM_PROFILE}
  (ENV.keys-ignore_env).select{|x| x =~ /\A[A-Z_]*\Z/}.each do |key|
    c.filter_sensitive_data("<#{key}>") { ENV[key] }
  end
  c.default_cassette_options = { :record => :once }
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true 
end

