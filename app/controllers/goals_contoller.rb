class GoalsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show_sub_goal show_bits_goal]

  before_action :set_user, only: %i[show_sub_goal show_bits_goal]
  before_action :check_token, only: %i[show_sub_goal show_bits_goal]

  def show_sub_goal
    @sub_goal = @user.sub_goals.in_progress.first
    render layout: 'on_stream'
  end

  def show_bits_goal
    @sub_goal = @user.bits_goals.in_progress.first
    render layout: 'on_stream'
  end

  private

  def set_user
    @user = User.find_bot(params[:user_id])
  end

  def check_token
    return unless params[:token].blank? || @user.token != params[:token]
    flash[:alert] = "You don't have access to this boss game !"
    redirect_to :root
  end
end
