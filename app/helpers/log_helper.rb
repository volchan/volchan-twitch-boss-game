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

  private

  def log_renderer(log)
    case log.log_type
    when 'sub' then sub_prime_or_dollars(log)
    when 'resub' then resub_prime_or_dollars(log)
    when 'bits' then render 'logs/bits', log: log
    when 'attack' then render 'logs/attack', log: log
    when 'dmg_shield' then render 'logs/dmg_shield', log: log
    when 'dmg_hp' then render 'logs/dmg_hp', log: log
    when 'add_shield' then render 'logs/add_shield', log: log
    when 'heal_hp' then render 'logs/heal_hp', log: log
    when 'new_boss' then render 'logs/new_boss', log: log
    end
  end

  def sub_prime_or_dollars(log)
    if log.sub_plan == 'Prime'
      render 'logs/prime', log: log
    else
      render 'logs/sub', log: log
    end
  end

  def resub_prime_or_dollars(log)
    if log.sub_plan == 'Prime'
      render 'logs/prime', log: log
    else
      render 'logs/resub', log: log
    end
  end
end
