require 'rubygems'
require 'yaml'
require 'win32/service'
include Win32

class EchiDaemon < Daemon
  #Determine our working directory
  $workingdir = File.expand_path File.dirname(__FILE__) 
  require $workingdir + '/echi-converter.rb'
  include EchiConverter
    
  def service_stop
    @log.info "ECHI-Converter service stopped"
    @log.close
  end

  def service_pause
    @log.info "ECHI-Converter service paused"
  end

  def service_resume
    @log.info "ECHI-Converter service resumed"
  end
  
  def service_init
    #Open the configuration file
    configfile = $workingdir + '/../config/application.yml' 
    $config = YAML::load(File.open(configfile))

    #Load ActiveRecord Models
    if $config["pco_process"] == 'Y'
      require $workingdir + '/database_presence.rb'
    else
      require $workingdir + '/database.rb'
    end

    #Load the configured schema
    schemafile = $workingdir + "/../config/" + $config["echi_schema"]
    @echi_schema = YAML::load(File.open(schemafile))

    #Open the logfile with appropriate output level
    initiate_logger
    @log.info "ECHI-Converter service initializing"
    $init_date = Time.now
    
    #If configured for database insertion, connect to the database
    if $config["export_type"] == 'database' || $config["export_type"] == 'both'
      connect_database
    end
  end

  def service_main
    @log.info "ECHI-Converter service started"
    while running?
      if state == RUNNING
        #Process the files
        fetch_ftp_files
        #Grab filenames from the to_process directory after an FTP fetch, so if the 
        #system fails it may pick up where it left off
        to_process_dir = $workingdir + "/../files/to_process/"
  
        #Establish where to copy the processed files to
        @processeddirectory = set_directory($workingdir)
  
        Dir.entries(to_process_dir).each do | file |
          if file.slice(0,3) == 'chr'
            if $config["echi_format"] == 'BINARY'
              record_cnt = convert_binary_file file
            elsif $config["echi_format"] == 'ASCII'
              record_cnt = process_ascii file
            end
            @log.info "Processed file #{file} with #{record_cnt.to_s} records"
          end
        end
        
        if $config["echi_update_agent_data"] == "Y"
          process_agent_data
        end
        
        sleep $config["fetch_interval"]

        #Make sure we did not lose our database connection while we slept
        if ActiveRecord::Base.connected? == 'FALSE'
          connect_database
        end
      end
      
      if state == PAUSED
        @log.info "ECHI-Converter service paused"
        sleep $config["fetch_interval"]
      end
    end
  end
end

d = EchiDaemon.new
d.mainloop