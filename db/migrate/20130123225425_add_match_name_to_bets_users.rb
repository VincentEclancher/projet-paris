class AddMatchNameToBetsUsers < ActiveRecord::Migration
  def change
    add_column :bets_users, :match, :string
  end
end
