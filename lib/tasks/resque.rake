require 'resque/tasks'  
require 'resque_scheduler/tasks'

task "resqusetup" => :environment  

namespace :resque do
 task :setup do
    require 'resque'
    require 'resque_scheduler'
    require 'resque/scheduler'
    Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }      

    Resque.redis = 'localhost:6379'
    Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")
 end
end