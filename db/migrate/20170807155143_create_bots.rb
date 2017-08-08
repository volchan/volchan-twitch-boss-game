class CreateBots < ActiveRecord::Migration[5.0]
  def change
    create_table :bots do |t|
      t.string :name
      t.string :channel
      t.string :twitch_token
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
