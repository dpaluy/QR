#############################################################
# Application
#############################################################
set :user, 'ndsti'  # Your dreamhost account's username
set :project, 'NDS_QR'  # Your application as its called in the repository
set :account_domain, 'demo.paluy.org'


#############################################################
# Servers
#############################################################
set :domain, "paluy.org"  # Dreamhost servername where your account is located 
set :application, "#{account_domain}"  # Your app's location (domain or sub-domain name as setup in panel)
set :applicationdir, "/home/#{user}/#{application}"  # The standard Dreamhost setup
set :gem_path, '/home/ndsti/.gems:/usr/lib/ruby/gems/1.8'

role :web, domain
role :app, domain
role :db,  domain, :primary => true

#############################################################
# Subversion
#############################################################
set :scm, :subversion
set :scm_username, 'dpaluy'
set :scm_password, 'Pups78'
set :repository, "http://svn.paluy.org/projects/#{project}/trunk/"
set :checkout, "export"

# deploy config
set :deploy_to, applicationdir
set :deploy_via, :export

#############################################################
# Settings
#############################################################
default_run_options[:pty] = true  # Forgo errors when deploying from windows
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")] 
set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false


#############################################################
#	recipes
#############################################################
namespace :deploy do
  desc "This to do once we get the code up"
  task :after_update_code, :roles => :app, :except => { :no_release => true } do
#	run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
    run "cd #{release_path} && rake gems:install"
#    run "cd #{release_path} && RAILS_ENV=#{stage} ./script/runner Sass::Plugin.update_stylesheets"
    run "cd #{release_path} && RAILS_ENV=production rake db:migrate"
  end

  task :set_gem_path do
	run "mv #{current_release}/config/environment.rb #{current_release}/config/environment.rb.bak"
 	run "echo ENV[\\'GEM_PATH\\']=\\'#{gem_path}\\' >> #{current_release}/config/environment.rb"
 	run "cat #{current_release}/config/environment.rb.bak >> #{current_release}/config/environment.rb"
 	run "rm #{current_release}/config/environment.rb.bak"
  end

  desc "Server Start configuration settings"
  task :start do
     # nothing for Passenger
  end 

  desc "Symlink the upload directories"
  task :before_symlink do
	set_gem_path
  #   run "mkdir -p #{shared_path}/uploads"
  #   run "ln -s #{shared_path}/uploads #{release_path}/public/uploads"
  end

  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :sass do
  desc 'Updates the stylesheets generated by Sass'
  task :update, :roles => :app do
    invoke_command "cd #{latest_release}; RAILS_ENV=#{rails_env} rake sass:update"
  end

  # Generate all the stylesheets manually (from their Sass templates) before each restart.
  #before 'deploy:restart', 'sass:update'
end

namespace :db do
  desc 'Dumps the production database to db/production_data.sql on the remote server'
  task :remote_db_dump, :roles => :db, :only => { :primary => true } do
    run "cd #{deploy_to}/#{current_dir} && " +
      "rake RAILS_ENV=#{rails_env} db:database_dump --trace"
  end

  desc 'Downloads db/production_data.sql from the remote production environment to your local machine'
  task :remote_db_download, :roles => :db, :only => { :primary => true } do
    execute_on_servers(options) do |servers|
      self.sessions[servers.first].sftp.connect do |tsftp|
        tsftp.download!("#{deploy_to}/#{current_dir}/db/production_data.sql", "db/production_data.sql")
      end
    end
  end

  desc 'Cleans up data dump file'
  task :remote_db_cleanup, :roles => :db, :only => { :primary => true } do
    execute_on_servers(options) do |servers|
      self.sessions[servers.first].sftp.connect do |tsftp|
        tsftp.remove! "#{deploy_to}/#{current_dir}/db/production_data.sql"
      end
    end
  end

  desc 'Dumps, downloads and then cleans up the production data dump'
  task :remote_db_runner do
    remote_db_dump
    remote_db_download
    remote_db_cleanup
  end
end