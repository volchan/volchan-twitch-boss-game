class GameLogger
  def initialize(bot, boss)
    @bot = bot
    @boss = boss
  end

  def sub_log(attr)
    log_attr = {
      username: attr[:username],
      log_type: attr[:type],
      sub_plan: attr[:plan],
      message: attr[:message],
      month: attr[:month]
    }
    create_log(log_attr)
  end

  def bits_log(attr)
    log_attr = {
      username: attr[:username],
      log_type: attr[:event_type],
      bits_amount: attr[:amount],
      message: attr[:message]
    }
    create_log(log_attr)
  end

  def attack_log(attacker, amount)
    log_attr = {
      log_type: 'attack',
      username: attacker,
      amount: amount
    }
    create_log(log_attr)
  end

  def dmg_shield_log(attacker, amount)
    log_attr = {
      log_type: 'dmg_shield',
      username: attacker,
      amount: amount
    }
    create_log(log_attr)
  end

  def dmg_hp_log(attacker, amount)
    log_attr = {
      log_type: 'dmg_hp',
      username: attacker,
      amount: amount
    }
    create_log(log_attr)
  end

  def add_shield_log(amount)
    log_attr = {
      log_type: 'add_shield',
      amount: amount
    }
    create_log(log_attr)
  end

  def heal_hp_log(amount)
    log_attr = {
      log_type: 'heal_hp',
      amount: amount
    }
    create_log(log_attr)
  end

  def new_boss_log
    log_attr = {
      log_type: 'new_boss'
    }
    create_log(log_attr)
  end

  def log_kill(attacker)
    log_attr(
      log_type: 'kill',
      username: attacker
    )
    create_log(log_attr)
  end

  def create_log(attr)
    log_attr = {
      bot: @bot,
      boss_name: @boss.name,
      boss_max_hp: @boss.max_hp,
      boss_current_hp: @boss.current_hp,
      boss_current_shield: @boss.current_shield,
      boss_max_shield: @boss.max_shield
    }
    new_log = Log.create!(log_attr.merge(attr))
    send_to_view(new_log)
  end

  def send_to_view(log)
    log_to_display = render_log(log)
    ActionCable.server.broadcast(
      "dashboard_#{log.bot.id}",
      log: log_to_display
    )
  end

  def render_log(log)
    ApplicationController.new.render_to_string(
      partial: log_partial(log),
      locals: { log: log, user: log.bot.user },
      layout: false
    )
  end

  def log_partial(log)
    if log.sub_plan == 'Prime'
      prime_sub_or_resub(log)
    else
      "logs/#{log.log_type}"
    end
  end

  def prime_sub_or_resub(log)
    if log.log_type == 'sub'
      'logs/prime'
    else
      'logs/resub_prime'
    end
  end
end
