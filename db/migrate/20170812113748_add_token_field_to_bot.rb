class AddTokenFieldToBot < ActiveRecord::Migration[5.0]
  def change
    add_column :bots, :token, :string
  end
end
