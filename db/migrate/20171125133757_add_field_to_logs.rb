class AddFieldToLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :logs, :gifted_to, :string
  end
end
