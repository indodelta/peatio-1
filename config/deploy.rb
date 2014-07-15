
# config valid only for Capistrano 3.1
# require 'capistrano/setup'

# # Includes default deployment tasks
   require 'capistrano/deploy'
#   require 'rvm1/capistrano3'
   require 'capistrano/rvm'
# # # require 'capistrano/rbenv'
# # # require 'capistrano/chruby'
   require 'capistrano/bundler'
   require 'capistrano/rails/assets'
   require 'capistrano/rails/migrations'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
#require "bundler/capistrano"
lock '3.2.1'

set :stage, :production
set :application, '104.131.224.194'
set :repo_url, 'git@github.com:sandy1987/peatio.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
 set :deploy_to, '/home/root/peatio'

# Default value for :scm is :git
 set :scm, :git

# Default value for :format is :pretty
 set :format, :pretty

# Default value for :log_level is :debug
 set :log_level, :debug

# Default value for :pty is false
 #set :pty, true
 set :ssh_options, {:forward_agent => true}
 set :default_run_options, {:pty => true}

 set :user, "root"
 role :web, "104.131.224.194"
 role :app, "104.131.224.194"
 role :db,  "104.131.224.194", :primary => true

after "deploy:restart", "deploy:cleanup"
 after "deploy:migrate", "deploy:migrate"
 #after "deploy", "rvm:trust_rvmrc"

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5
SSHKit.config.output = $stdout
SSHKit.config.output_verbosity = Logger::DEBUG
SSHKit.config.command_map[:rake] = "bundle exec rake"
SSHKit.config.command_map[:rails] = "bundle exec rails"
namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
     # execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  desc "run bundle install and ensure all gem requirements are met"
  task :install do
  #  run "cd #{current_path} && bundle install"
  end
  # desc "Run seed file"
  #  task :migrate do
  #   on roles(:app) do
  #    run "cd #{current_path} && bundle exec  rake db:seed RAILS_ENV=production"
  #   end
  #  end
  #  desc "Run pending migrations on already deployed code"
  #  task :migrate do
  #    on roles(:app) do
  #      run "cd #{current_path} && bundle exec  rake db:migrate RAILS_ENV=production"
  #    end
  #  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end