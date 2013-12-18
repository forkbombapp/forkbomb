# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Forkbomb::Application.load_tasks

if ENV['RAILS_ENV']=='test'
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
  task :default => [:spec, :cucumber, 'coveralls:push']
end
