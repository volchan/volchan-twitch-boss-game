class ChangeBossGameToBoss < ActiveRecord::Migration[5.0]
  def change
    rename_table :boss_games, :bosses
  end
end
