class AddMaxShieldToBosses < ActiveRecord::Migration[5.0]
  def change
    add_column :bosses, :max_shield, :integer
  end
end
