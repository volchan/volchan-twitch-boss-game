module StripeApiHelper
  def check_user_subscription(user)
    StripeApi.new(user).check_subscription
  end
end
