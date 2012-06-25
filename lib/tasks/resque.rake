require 'resque/tasks'  
require 'resque_scheduler/tasks'

namespace :resque do
 task :setup do
    require 'resque'
    require 'resque_scheduler'
    require 'resque/scheduler'
    require 'resque_scheduler/server'
    Dir["#{Rails.root}/app/jobs/*.rb"].each{ |file| require file }
    ENV['QUEUE'] ||= '*'
    Resque.redis = '0.0.0.0:6379'
    Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")
    Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
 end
end