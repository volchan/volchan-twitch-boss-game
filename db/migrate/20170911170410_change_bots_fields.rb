class ChangeBotsFields < ActiveRecord::Migration[5.0]
  def change
    remove_column :bots, :twitch_token
    remove_column :bots, :name
    add_column :bots, :max_boss_hp, :integer
    add_column :bots, :min_boss_hp, :integer
    add_column :bots, :boss_hp_step, :integer
  end
end
