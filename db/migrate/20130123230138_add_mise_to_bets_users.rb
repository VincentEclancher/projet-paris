class AddMiseToBetsUsers < ActiveRecord::Migration
  def change
    add_column :bets_users, :mise, :float
  end
end
