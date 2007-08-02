require 'rubygems'
require 'yaml'

#Determine our working directory
@workingdirectory = File.expand_path(File.dirname(__FILE__))
require @workingdirectory + '/echi-converter.rb'
include EchiConverter

#Load ActiveRecord Models
require @workingdirectory + '/database.rb'

configfile = @workingdirectory + '/../config/application.yml' 

#Open the configuration file
@config = YAML::load(File.open(configfile))

#Load the configured schema
schemafile = @workingdirectory + "/../config/" + @config["echi_schema"]
@echi_schema = YAML::load(File.open(schemafile))

#Open the logfile with appropriate output level
initiate_logger
  
#If configured for database insertion, connect to the database
if @config["export_type"] == 'database' || @config["export_type"] == 'both'
  connect_database
end

@log.info "Running..."

loop do
  #Process the files
  files = fetch_ftp_files
  files.each do | file |
    record_cnt = convert_binary_file file
    @log.info "Processed file #{file} with #{record_cnt.to_s} records"
  end

  sleep @config["fetch_interval"]

  #Make sure we did not lose our database connection while we slept
  if ActiveRecord::Base.connected? == 'FALSE'
    connect_database
  end
end

#Close the logfile
@log.info "Shutdown..."
@log.close