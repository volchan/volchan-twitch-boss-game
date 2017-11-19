module Dashboard
  class SubscriptionsController < ApplicationController
    def new
      skip_authorization
      return unless subscribed?
      flash[:notice] = 'You are allready subscribed !'
      redirect_to_dashboard
    end

    def create
      skip_authorization
      strp_api = StripeApi.new(current_user)

      customer = strp_api.find_or_create_custormer(params)
      return card_error(strp_api) unless strp_api.create_subscription(customer)

      StripeMailer.subscription(current_user).deliver_now
      flash[:notice] = 'Thank you for subscribing'
      redirect_to_dashboard
    end

    private

    def card_error(strp_api)
      errors = strp_api.errors.join(' ')
      flash[:alert] = errors
      redirect_to new_dashboard_subscription_path
    end

    def redirect_to_dashboard
      return redirect_to new_dashboard_bot_path if current_user.bot.nil?
      redirect_to dashboard_root_path
    end

    def subscribed?
      check_user_subscription
    end

    def check_user_subscription
      return false if current_user.stripe_id.nil?
      StripeApi.new(current_user).check_subscription
    end
  end
end
