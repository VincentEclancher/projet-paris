class AddGainToBetsUsers < ActiveRecord::Migration
  def change
    add_column :bets_users, :gain, :float
  end
end
