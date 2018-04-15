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

  def display_pause_btn(goal)
    case goal.status
    when 'in_progress'
      link_to dashboard_pause_goal_path(goal), class: 'btn btn-warning btn-block text-light', method: :patch, remote: true do
        "
          <i class='fa fa-pause'></i>
          Pause #{goal.g_type.humanize}
        ".html_safe
      end
    when 'paused'
      link_to dashboard_pause_goal_path(goal), class: 'btn btn-success btn-block', method: :patch, remote: true do
        "
          <i class='fa fa-play'></i>
          Resume #{goal.g_type.humanize}
        ".html_safe
      end
    end
  end
end
