class StripeMailer < ApplicationMailer
  def subscription(user)
    @user = user
    @subscription = StripeApi.new(user).retrieve_subscription
    mail to: @user.email, subject: 'Your subscription'
  end
end
