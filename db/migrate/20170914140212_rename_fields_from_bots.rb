class RenameFieldsFromBots < ActiveRecord::Migration[5.0]
  def change
    rename_column :bots, :max_boss_hp, :boss_max_hp
    rename_column :bots, :min_boss_hp, :boss_min_hp
  end
end
