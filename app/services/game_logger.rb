class GameLogger
  def initialize(bot, boss)
    @bot = bot
    @boss = boss
    @username = nil
  end

  def sub_log(attr)
    log_attr = {
      bot: @bot,
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
      bot: @bot,
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
      bot: @bot,
      log_type: 'attack',
      username: attacker,
      amount: amount,
      boss_name: @boss.name,
      boss_max_hp: @boss.max_hp,
      boss_current_hp: @boss.current_hp,
      boss_current_shield: @boss.current_shield,
      boss_max_shield: @boss.max_shield
    }
    create_log(log_attr)
  end

  def create_log(attr)
    Log.create!(attr)
  end
end
