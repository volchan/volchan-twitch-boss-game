module Dashboard
  class DashboardsController < ApplicationController
    def show
      # subscribed?
      return authorize current_user if current_user.bot.nil?
      authorize @bot = Bot.find_with_user(current_user)
      @logs = Log.find_with_bot(@bot).page(params[:page])
      @sub_goal = current_user.current_sub_goal
      @achieved_sub_goals = current_user.sub_goals.achieved
      @bits_goal = current_user.current_bits_goal
      @achieved_bits_goals = current_user.bits_goals.achieved
    end

    private

    def subscribed?
      return if check_user_subscription
      redirect_to new_dashboard_subscription_path
    end

    def check_user_subscription
      return if current_user.stripe_id.nil?
      StripeApi.new(current_user).check_subscription
    end
  end
end
