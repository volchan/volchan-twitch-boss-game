class StripeMailer < ApplicationMailer
  def subscription(user)
    @user = user
    mail to: @user.email, subject: 'Your subscription'
  end
end
