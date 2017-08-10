class Bot < ApplicationRecord
  belongs_to :user
  has_many :bot_threads, dependent: :destroy
  has_many :boss_games, dependent: :destroy

  validates :name, presence: true
  validates :channel, presence: true
  validates :twitch_token, presence: true
end
