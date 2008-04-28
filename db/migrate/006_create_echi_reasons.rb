class CreateEchiReasons < ActiveRecord::Migration
  def self.up
    #We create the table from the one defined in the application.yml file
    create_table "echi_reasons", :force => true do |t|
      @@echi_schema["echi_reasons"].each do | field |
        case field["type"]
        when 'int'
          t.column field["name"], :integer, :limit => field["length"], :precision => field["length"], :scale => 0
        when 'str'
          t.column field["name"], :string, :limit => field["length"]
        when 'datetime'
          t.column field["name"], :datetime
        when 'bool'
          t.column field["name"], :string, :limit => 1
        when 'boolint'
          t.column field["name"], :string, :limit => 1
        end
      end
    end
  end

  def self.down
    drop_table "echi_reasons"
  end
end