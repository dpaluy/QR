namespace :svn do
  desc "Adds all files with an svn status flag of '?'" 
  task(:add_new) { 'svn status | awk '/\\?/ {print $2}' | xargs svn add' }
end
