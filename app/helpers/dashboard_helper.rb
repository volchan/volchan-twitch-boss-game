module DashboardHelper
  def render_dashboard(user, bot)
    return render 'no_bot_index' if bot.blank?
    render 'with_bot_index'
  end
end