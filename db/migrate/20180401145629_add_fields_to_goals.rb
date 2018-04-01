class AddFieldsToGoals < ActiveRecord::Migration[5.1]
  def change
    add_column :goals, :status, :integer, default: 0
    add_column :goals, :title, :string
  end
end
