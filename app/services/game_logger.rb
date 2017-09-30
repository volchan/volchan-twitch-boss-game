class GameLogger
  def initialize(bot, boss)
    @bot = bot
    @boss = boss
    @username = nil
  end

  def sub_log(attr)
    log_attr = {
      bot: @bot,
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
      log_type: attr[:event_type],
      bits_amount: attr[:amount],
      message: attr[:message],
      month: attr[:month]
    }
    create_log(log_attr)
  end

  def create_log(attr)
    Log.create!(attr)
  end
end
