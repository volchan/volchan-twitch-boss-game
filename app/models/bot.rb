class Bot < ApplicationRecord
  belongs_to :user
  has_one :boss, dependent: :destroy

  validates :name, presence: true
  validates :channel, presence: true
  validates :twitch_token, presence: true

  before_create :generate_token

  private

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Bot.exists?(token: random_token)
    end
  end
end
