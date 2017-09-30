class AddMonthToLogs < ActiveRecord::Migration[5.0]
  def change
    add_column :logs, :month, :integer
  end
end
