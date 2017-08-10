class AddFieldsToBossGame < ActiveRecord::Migration[5.0]
  def change
    add_column :boss_games, :shield, :integer, default: 0
    add_column :boss_games, :avatar, :string
  end
end
