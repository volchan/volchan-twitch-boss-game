class AddFieldToBossGame < ActiveRecord::Migration[5.0]
  def change
    add_column :boss_games, :saved_at, :datetime
  end
end
