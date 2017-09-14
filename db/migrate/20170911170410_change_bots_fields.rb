class ChangeBotsFields < ActiveRecord::Migration[5.0]
  def change
    remove_column :bots, :twitch_token, :string
    remove_column :bots, :name, :string
    add_column :bots, :max_boss_hp, :integer
    add_column :bots, :min_boss_hp, :integer
    add_column :bots, :boss_hp_step, :integer
  end
end
