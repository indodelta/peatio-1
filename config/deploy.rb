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

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end
