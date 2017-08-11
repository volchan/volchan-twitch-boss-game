class Bot < ApplicationRecord
  belongs_to :user
  has_one :boss_game, dependent: :destroy

  validates :name, presence: true
  validates :channel, presence: true
  validates :twitch_token, presence: true
end
