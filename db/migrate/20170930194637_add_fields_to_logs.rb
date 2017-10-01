class AddFieldsToLogs < ActiveRecord::Migration[5.0]
  def change
    add_column :logs, :boss_max_hp, :integer
    add_column :logs, :boss_current_hp, :integer
    add_column :logs, :boss_current_shield, :integer
    add_column :logs, :boss_max_shield, :integer
  end
end
