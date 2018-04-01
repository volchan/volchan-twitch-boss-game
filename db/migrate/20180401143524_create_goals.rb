class CreateGoals < ActiveRecord::Migration[5.1]
  def change
    create_table :goals do |t|
      t.integer :g_type
      t.integer :required, default: 0
      t.integer :current, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
