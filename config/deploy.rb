require "rvm/capistrano"
require "bundler/capistrano"

set :application, "104.131.224.194"
set :deploy_to, "/home/root/peatio/#{application}"
set :repository,  "git@github.com:sandy1987/peatio.git"
set :port, 22
set :use_sudo, true
set :user_sudo, false
set :rails_env, "production" # sets your server environment to Production mode
set :ssh_options, { :forward_agent => true }
set :scm, :git  # sets version control
set :default_shell, "/bin/bash -l"
set :rvm_bin_path, "/usr/local/rvm/bin"

default_run_options[:pty] = true
set :user, "root"
role :web, application
role :app, application
role :db,  application, :primary => true
before 'deploy:setup', 'rvm:install_rvm'
after "deploy:restart", "deploy:cleanup"
after "deploy", "rvm:trust_rvmrc"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Create Solr Directory"
  task :setup_solr_data_dir do
    run "mkdir -p #{shared_path}/solr/data"
  end
end

namespace :solr do
  desc "start solr"
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec sunspot-solr start --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids > /dev/null 2>&1 || true"
  end
  desc "stop solr"
  task :stop, :roles => :app, :except => { :no_release => true } do
    run ("cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec sunspot-solr stop --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids > /dev/null 2>&1 || true")
  end
  desc "reindex the whole database"
  task :reindex, :roles => :app do
    stop
    run "rm -rf #{shared_path}/solr/data"
    start
    run "cd #{current_path} && yes | RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:reindex"
  end
end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end
