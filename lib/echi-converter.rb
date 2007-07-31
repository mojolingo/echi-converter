require 'rubygems'
require 'active_record'
require 'faster_csv'
require 'net/ftp'
require 'net/ssh'
#require 'net/sftp'
require 'fileutils'

class Logger
  #Change the logging format to include a timestamp
  def format_message(severity, timestamp, progname, msg)
    "#{timestamp} (#{$$}) #{msg}\n" 
  end
end

module EchiConverter
  
  def connect_database
    databaseconfig = @workingdirectory + '/../config/database.yml'
    dblogfile = @workingdirectory + '/../log/database.log'
    ActiveRecord::Base.logger = Logger.new(dblogfile, @config["log_number"], @config["log_length"])  
    case @config["log_level"]
      when 'FATAL'
        ActiveRecord::Base.logger.level = Logger::FATAL
      when 'ERROR'
        ActiveRecord::Base.logger.level = Logger::ERROR
      when 'WARN'
        ActiveRecord::Base.logger.level = Logger::WARN
      when 'INFO'
        ActiveRecord::Base.logger.level = Logger::INFO
      when 'DEBUG'
        ActiveRecord::Base.logger.level = Logger::DEBUG
    end
    begin
      ActiveRecord::Base.establish_connection(YAML::load(File.open(databaseconfig))) 
      @log.info "Successfully connected to the database"
    rescue => err
      @log.fatal "Could not connect to the database - " + err
    end
  end
  
  #Method to open our application log
  def initiate_logger
    logfile = @workingdirectory + '/../log/application.log'
    @log = Logger.new(logfile, @config["log_number"], @config["log_length"])
    case @config["log_level"]
      when 'FATAL'
        @log.level = Logger::FATAL
      when 'ERROR'
        @log.level = Logger::ERROR
      when 'WARN'
        @log.level = Logger::WARN
      when 'INFO'
        @log.level = Logger::INFO
      when 'DEBUG'
        @log.level = Logger::DEBUG
    end
  end
  
  #Method for parsing the various datatypes from the ECH file
  def dump_binary type, length
    case type
    when 'int' 
      #Process integers, assigning appropriate profile based on length
      #such as long int, short int and tiny int.
      case length
      when 4
        value = @binary_file.read(length).unpack("l").first.to_i
      when 2
        value = @binary_file.read(length).unpack("s").first.to_i
      when 1
        value = @binary_file.read(length).unpack("U").first.to_i
      end
    #Process appropriate intergers into datetime format in the database
    when 'datetime'
      case length 
      when 4
        value = @binary_file.read(length).unpack("l").first.to_i
        value = Time.at(value)
      end
    #Process strings
    when 'str'
      value = @binary_file.read(length).unpack("M").first.to_s.rstrip
    #Process individual bits that are booleans
    when 'bool'
      value = @binary_file.read(length).unpack("b8").last.to_s
    #Process that one wierd boolean that is actually an int, instead of a bit
    when 'bool_int'
      value = @binary_file.read(length).unpack("U").first.to_i
    end
    return value
  end
  
  #Mehtod that performs the conversions
  def convert_binary_file filename
    #Open the file to process
    echi_file = @workingdirectory + "/../files/to_process/" + filename
    @binary_file = open(echi_file,"rb")
    @log.debug "File size: " + @binary_file.stat.size.to_s
    
    #Read header information first
    filenumber = dump_binary 'int', 4
    @log.debug "File_number " + filenumber.to_s
    fileversion = dump_binary 'int', 4
    @log.debug "Version " + fileversion.to_s

    #Log the file
    echi_log = EchiLog.new
    echi_log.filename = filename
    echi_log.filenumber = filenumber
    echi_log.version = fileversion
    
    bool_cnt = 0
    record_cnt = 0
    while @binary_file.eof == FALSE do 
      @log.debug '<====================START RECORD====================>'
      echi_record = EchiRecord.new
      @echi_schema["fields"].each do | field |
        #We handle the 'boolean' fields differently, as they are all encoded as bits in a single 8-bit byte
        if field["type"] == 'bool'
          if bool_cnt == 0
            value = dump_binary field["type"], field["length"]
          end
          #@log.debug field ["name"] + "{ type => #{field["type"]} & length => #{field["length"]} } value => " + value.slice(bool_cnt, 1)
          bool_cnt += 1
          if bool_cnt == 8
            bool_cnt = 0
          end
        else
          #Process 'standard' fields
          value = dump_binary field["type"], field["length"]
          @log.debug field["name"] + " { type => #{field["type"]} & length => #{field["length"]} } value => " + value.to_s
        end
        echi_record[field["name"]] = value
      end
      echi_record.save
      
      #Scan past the end of line record
      @binary_file.read(1)
      record_cnt += 1
    end
    @log.debug '<====================STOP RECORD====================>'
    @binary_file.close
    
    #Move the file to the processed directory
    destination_directory = @workingdirectory + '/../files/processed/'
    FileUtils.mv(echi_file, destination_directory)
    
    #Finish logging the details on the file
    echi_log.records = record_cnt
    echi_log.processed_at = Time.now
    echi_log.save
    
    return record_cnt
  end
  
  def connect_ftpsession
    #Open ftp connection
    begin
      if @config["echi_connect_type"] == 'ftp'
        ftp_session = Net::FTP.new(@config["echi_host"])
        ftp_session.login @config["echi_username"], @config["echi_password"]
        @log.info "Successfully connected to the ECHI FTP server"
      else
        #Stub for possible SSH support in the future
        #session = Net::SSH.start(config["echi_host"], config["echi_port"], config["echi_username"], config["echi_password"])
        @log.fatal "SSH currently not supported, please use FTP for accessing the ECHI server"
        exit
      end
    rescue => err
      @log.fatal "Could not connect with the FTP server - " + err
      return -1
    end
    return ftp_session
  end
  
  #Connect to the ftp server and fetch the files each time
  def fetch_ftp_files
   attempts = 0
   ftp_session = -1
   files_to_process = Array.new
   while ftp_session == -1 do
     ftp_session = connect_ftpsession
     if ftp_session == -1
       sleep 5
     end
     attempts += 1
     if @config["echi_ftp_retry"] == attempts
       ftp_session = 0
     end
   end
   if ftp_session != 0
     begin
       ftp_session.chdir(@config["echi_ftp_directory"])
       files = ftp_session.list('chr*')
       file_cnt = 0
       files.each do | file |
         #ACTION:  Need to detect which OS we are running on and then parse the ftp data appropriately
         file_data = file.split(' ')
         remote_filename = file_data[8]
         local_filename = @workingdirectory + '/../files/to_process/' + remote_filename
         ftp_session.getbinaryfile(remote_filename, local_filename)
         files_to_process[file_cnt] = remote_filename
         file_cnt += 1
       end
       ftp_session.close
    rescue => err
      @log.fatal "Could not fetch from ftp server - " + err
    end
   end
   return files_to_process
  end
end

require @workingdirectory + '/echi-converter/version.rb'
