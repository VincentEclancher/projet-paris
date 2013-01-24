class CreateFileParsing < ActiveRecord::Migration
  def up
    create_table :file_parsing, :id => false do |t|
      t.datetime :last_parse_date, :null => false

      t.timestamps
    end
  end
 
  def down
    drop_table :file_parsing
  end
end
