require 'active_record'

settings = YAML.load_file(File.expand_path('config/database.yml'))['test']

ActiveRecord::Base.establish_connection settings.to_hash
