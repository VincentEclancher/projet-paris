class CreateBets < ActiveRecord::Migration
  def up
    create_table :bets, :id => false do |t|
      t.integer :bet_id, :null => false
      t.string :match_name, :null => false
      t.integer :match_id, :null => false
      t.string :event_name, :null => false
      t.string :sport_name, :null => false
      t.string :type_of_bet
      t.date :start_date
      t.date :start_time
      t.date :end_date
      t.date :end_time

      t.timestamps
    end
  end
 
  def down
    drop_table :bets
  end
end
