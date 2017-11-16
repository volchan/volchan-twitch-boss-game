module Dashboard
  class SubscriptionsController < ApplicationController
    def new
      skip_authorization
    end

    def create
      skip_authorization
      stripe_api = StripeApi.new(current_user)

      customer = stripe_api.find_or_create_custormer(params)
      stripe_api.create_subscription(customer)

      return redirect_to new_dashboard_bot_path if current_user.bot.nil?
      redirect_to dashboard_root_path
    end
  end
end
