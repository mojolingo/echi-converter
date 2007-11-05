class CreateEchiLogs < ActiveRecord::Migration
  def self.up
    create_table "echi_agents", :force => true do |t|
      t.column "group_id", :string
      t.column "login_id", :string
      t.column "name", :string
    end
    add_index "echi_agents", "login_id"
  end

  def self.down
    remove_index "echi_agents", "login_id"
    drop_table "echi_agents"
  end
end