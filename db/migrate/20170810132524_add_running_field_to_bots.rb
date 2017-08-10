class AddRunningFieldToBots < ActiveRecord::Migration[5.0]
  def change
    add_column :bots, :running, :boolean, default: false
  end
end
