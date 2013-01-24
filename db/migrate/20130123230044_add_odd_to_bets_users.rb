class AddOddToBetsUsers < ActiveRecord::Migration
  def change
    add_column :bets_users, :cote, :float
  end
end
