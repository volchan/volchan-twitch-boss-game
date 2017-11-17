module Dashboard
  class SubscriptionsController < ApplicationController
    def new
      skip_authorization
    end

    def create
      skip_authorization
      strp_api = StripeApi.new(current_user)

      customer = strp_api.find_or_create_custormer(params)
      return card_error(strp_api) unless strp_api.create_subscription(customer)

      flash[:notice] = 'Thank you for subscribing'
      return redirect_to new_dashboard_bot_path if current_user.bot.nil?
      redirect_to dashboard_root_path
    end

    private

    def card_error(strp_api)
      errors = strp_api.errors.join(' ')
      flash[:alert] = errors
      redirect_to new_subscription_path
    end
  end
end
