module LogHelper
  def log_display(log)
    return render 'logs/no_logs' if log.nil?
    log_renderer(log)
  end

  def sub_plan_display(plan)
    case plan
    when '1000' then '$4.99'
    when '2000' then '$9.99'
    when '3000' then '$24.99'
    end
  end

  def display_log_created_at(log, user)
    log.created_at.in_time_zone(user.time_zone).strftime('%F %H:%M')
  end

  private

  def log_renderer(log)
    if log.sub_plan == 'Prime'
      prime_sub_or_resub(log)
    else
      render "logs/#{log.log_type}", log: log, user: current_user
    end
  end

  def prime_sub_or_resub(log)
    if log.log_type == 'sub'
      render 'logs/prime', log: log, user: current_user
    else
      render 'logs/resub_prime', log: log, user: current_user
    end
  end
end
