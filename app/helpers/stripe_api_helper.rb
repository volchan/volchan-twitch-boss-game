module StripeApiHelper
  def check_user_subscription(user)
    return if user.stripe_id.nil?
    StripeApi.new(user).check_subscription
  end

  def form_priority_country
    ISO3166::Country.find_all_countries_by_region('Europe')
                    .map{ |c| c.data['un_locode'] }
                    .insert(1, 'US')
                    .sort
  end
end
