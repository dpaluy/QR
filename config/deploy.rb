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
# Passenger
#############################################################
namespace :passenger do
  desc "Restart Application"
  task :restart do
    rake app:render 
    run "touch #{applicationdir}/tmp/restart.txt"
  end
end

after :deploy, "passenger:restart"
