class AddFieldsToBotThread < ActiveRecord::Migration[5.0]
  def change
    add_column :bot_threads, :name, :string
    add_column :bot_threads, :channel, :string
    add_column :bot_threads, :twitch_token, :string
  end
end
