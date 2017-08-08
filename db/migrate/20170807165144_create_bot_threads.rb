class CreateBotThreads < ActiveRecord::Migration[5.0]
  def change
    create_table :bot_threads do |t|
      t.references :bot, foreign_key: true

      t.timestamps
    end
  end
end
