class RenameShieldFromBosses < ActiveRecord::Migration[5.0]
  def change
    rename_column :bosses, :shield, :current_shield
  end
end
