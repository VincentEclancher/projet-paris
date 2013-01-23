class CreateBetsUsers < ActiveRecord::Migration
  def up
    create_table :bets_users, :id => false do |t|
      t.integer :user_id, :null => false
      t.integer :bet_id, :null => false

      t.timestamps
    end
  end
 
  def down
    drop_table :bets_users
  end
end
