set :application, "audit.amee.com"
set :deploy_to,  "/var/www/audit"

set :scm, :git
set :git_enable_submodules,1
set :git_shallow_clone, 1
set :repository,  "git@github.com:AMEE/provenance.prototype.git"


# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :user, "jamespjh"
set :domain, "ec2-79-125-29-100.eu-west-1.compute.amazonaws.com"
server domain, :app, :web

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, true
set :rails_env, "staging"
set :rake_path, "rake"

#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

after "deploy:symlink", "myamee:copy_config"


namespace :myamee do
  desc "Make copy of my_amee.yml on server"
  task :copy_config do
    run "cp #{shared_path}/config/my_amee.yml #{release_path}/config/my_amee.yml"
  end
end

#############################################################
# Passenger
#############################################################

namespace :passenger do
desc "Restart Application"
task :restart, :roles => :app do
run "touch #{current_path}/tmp/restart.txt"
end
end

namespace :deploy do
desc "Restart the Passenger system."
task :restart, :roles => :app do
passenger.restart
end
end