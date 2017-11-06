module StripeApiHelper
  def check_user_subscription(user)
    return if user.stripe_id.nil?
    StripeApi.new(user).check_subscription
  end
end
