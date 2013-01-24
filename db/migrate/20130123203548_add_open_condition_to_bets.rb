class AddOpenConditionToBets < ActiveRecord::Migration
  def change
    add_column :bets, :is_opened, :boolean, :default => true
  end
end
