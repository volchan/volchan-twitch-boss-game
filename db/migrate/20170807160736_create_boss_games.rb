class CreateBossGames < ActiveRecord::Migration[5.0]
  def change
    create_table :boss_games do |t|
      t.references :bot, foreign_key: true
      t.string :name
      t.integer :max_hp
      t.integer :current_hp

      t.timestamps
    end
  end
end
