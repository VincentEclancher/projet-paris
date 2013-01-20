class CreateOdds < ActiveRecord::Migration
  def up
    create_table :odds, :id => false do |t|
      t.integer :odd_id, :null => false
      t.integer :bet_id, :null => false
      t.string :name, :null => false
      t.float :odd, :null => false

      t.timestamps
    end
  end
 
  def down
    drop_table :odds
  end
end