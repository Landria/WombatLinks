 namespace :bootstrap do
      desc "Add the default user"
      task :default_user => :environment do
        User.create( :email => 'anonymous@mail.com', :password => 'password' )
      end

      desc "Create the admin user"
      task :default_admin => :environment do
        u = User.create( :email => 'admin@admin.com', :password => 'admin' )
      end

      desc "Run all bootstrapping tasks"
      task :all => [:default_user, :default_admin]
    end