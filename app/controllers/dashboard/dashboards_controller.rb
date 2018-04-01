module Dashboard
  class DashboardsController < ApplicationController
    def show
      # subscribed?
      return authorize current_user if current_user.bot.nil?
      authorize @bot = Bot.find_with_user(current_user)
      authorize @logs = Log.find_with_bot(@bot).page(params[:page])
      authorize @sub_goal = current_user.sub_goals.in_progress
      authorize @achieved_sub_goals = current_user.sub_goals.achieved
      authorize @bits_goal = current_user.bits_goals.in_progress
      authorize @achieved_bits_goals = current_user.bits_goals.achieved
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
