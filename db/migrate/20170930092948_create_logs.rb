class CreateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :logs do |t|
      t.string :type
      t.string :username
      t.string :sub_plan
      t.integer :bits_amount
      t.string :message
      t.integer :amount
      t.string :boss_name
      t.references :bot, foreign_key: true

      t.timestamps
    end
  end
end
