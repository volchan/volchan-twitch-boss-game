class StripeMailer < ApplicationMailer
  def subscription(user)
    @user = user
    stripe_api = StripeApi.new(@user)
    @customer = stripe_api.find_customer
    @subscription = @customer.subscriptions.data.last
    @card = @customer.sources.first
    mail to: @user.email, subject: 'Your subscription'
  end
end
