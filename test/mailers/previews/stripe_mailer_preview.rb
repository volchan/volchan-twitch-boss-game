class StripeMailerPreview < ActionMailer::Preview
  def subscription
    user = User.first
    StripeMailer.subscription(user)
  end
end
