class AddCreditToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credit, :float, :null => false, :default => 40
  end
end