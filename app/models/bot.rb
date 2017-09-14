class Bot < ApplicationRecord
  belongs_to :user
  has_one :boss, dependent: :destroy

  validates :channel, presence: true
  validates :boss_max_hp, presence: true, numericality: { only_integer: true }
  validates :boss_min_hp, presence: true, numericality: { only_integer: true }
  validates :boss_hp_step, presence: true, numericality: { only_integer: true }

  before_create :generate_token

  private

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Bot.exists?(token: random_token)
    end
  end
end
