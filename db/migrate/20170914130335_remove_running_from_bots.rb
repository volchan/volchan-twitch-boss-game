class RemoveRunningFromBots < ActiveRecord::Migration[5.0]
  def change
    remove_column :bots, :running
  end
end
