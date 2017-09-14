class AddTokenToBosses < ActiveRecord::Migration[5.0]
  def change
    add_column :bosses, :token, :string
  end
end
