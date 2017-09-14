class ChangeDefaultOfSomeColumnsOfBots < ActiveRecord::Migration[5.0]
  def down
    change_column_default :bots, :boss_max_hp, nil
    change_column_default :bots, :boss_min_hp, nil
    change_column_default :bots, :boss_hp_step, nil
  end

  def up
    change_column_default :bots, :boss_max_hp, 5000
    change_column_default :bots, :boss_min_hp, 1000
    change_column_default :bots, :boss_hp_step, 200
  end
end
