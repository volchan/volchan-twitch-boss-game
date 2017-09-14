class RemoveSavedAtFromBosses < ActiveRecord::Migration[5.0]
  def change
    remove_column :bosses, :saved_at
  end
end
