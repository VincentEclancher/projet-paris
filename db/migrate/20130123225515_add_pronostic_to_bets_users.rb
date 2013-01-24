class AddPronosticToBetsUsers < ActiveRecord::Migration
  def change
    add_column :bets_users, :prono, :string
  end
end
