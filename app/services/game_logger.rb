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
    }
    create_log(log_attr)
  end

  def bits_log(attr)
    log_attr = {
      username: attr[:username],
      log_type: attr[:event_type],
      bits_amount: attr[:amount],
      message: attr[:message],
      month: attr[:month]
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
    Log.create!(log_attr.merge(attr))
  end
end
