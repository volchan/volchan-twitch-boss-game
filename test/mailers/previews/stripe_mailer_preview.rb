class StripeMailerPreview < ActionMailer::Preview
  def subscription
    user = User.find_by(username: 'summit1g')
    StripeMailer.subscription(user)
  end
end
