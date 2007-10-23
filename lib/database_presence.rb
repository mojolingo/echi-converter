class EchiRecord < ActiveRecord::Base
  set_table_name config["pco_record_tablename"]
  set_sequence_name config["pco_record_seqname"]
end

class EchiLog < ActiveRecord::Base
  set_table_name @config["pco_log_tablename"]
  set_sequence_name @config["pco_log_seqname"]
end
