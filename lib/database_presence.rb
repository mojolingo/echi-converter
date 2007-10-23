class EchiRecord < ActiveRecord::Base
  #Determine our working directory
  workingdirectory = File.expand_path(File.dirname(__FILE__))
  #Open the configuration file
  configfile = workingdirectory + '/../config/application.yml' 
  config = YAML::load(File.open(configfile))
  
  if config["pco_process"] == 'Y'
    set_table_name config["pco_record_tablename"]
    set_sequence_name config["pco_record_seqname"]
  end
end

class EchiLog < ActiveRecord::Base
  #Determine our working directory
  workingdirectory = File.expand_path(File.dirname(__FILE__))
  #Open the configuration file
  configfile = workingdirectory + '/../config/application.yml' 
  config = YAML::load(File.open(configfile))
  
  if config["pco_process"] == 'Y'
    set_table_name @config["pco_log_tablename"]
    set_sequence_name @config["pco_log_seqname"]
  end
end
