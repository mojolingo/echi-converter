class EchiRecord < ActiveRecord::Base
  set_table_name @config["PCO_ECHIRECORD"]
  set_sequence_name @config["PCO_ECHIRECORDSEQ"]
end

class EchiLog < ActiveRecord::Base
  set_table_name @config["PCO_ECHILOG"]
  set_sequence_name @config["PCO_ECHILOGSEQ"]
end
