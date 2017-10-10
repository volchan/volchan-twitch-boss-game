module TokenConcern
  extend ActiveSupport::Concern

  included do
    before_create :generate_token
  end

  private

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Bot.exists?(token: random_token)
    end
  end
end