require 'rubygems'
require 'rake'
require 'logger'
require 'active_record'
require 'yaml'

require 'yard'
YARD::Rake::YardocTask.new

##Add the ability to use ActiveRecord Migrations to create the database
desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate => :environment do
  # Load the working directory and configuration file
  workingdirectory = File.expand_path(File.dirname(__FILE__))
  config = YAML::load File.open("#{workingdirectory}/config/application.yml")

  # Load the configured schema
  @@echi_schema = YAML::load File.open(File.join(workingdirectory, "config", config["echi_schema"]))

  ActiveRecord::Migrator.migrate 'db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil
end

task :environment do
  ActiveRecord::Base.establish_connection YAML::load(File.open('config/database.yml'))
  ActiveRecord::Base.logger = Logger.new 'log/database.log'
end
