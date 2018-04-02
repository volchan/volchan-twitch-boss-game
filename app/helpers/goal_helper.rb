module GoalHelper
  def goals_link(goal)
    if goal.nil?
      nil
    elsif goal.sub_goal?
      "#{sub_goal_url}?user_id=#{current_user.id}&token=#{current_user.token}"
    elsif goal.bits_goal?
      "#{bits_goal_url}?user_id=#{current_user.id}&token=#{current_user.token}"
    end
  end
end
