class Game
  def initialize(boss)
    @boss = boss
    @bot = boss.bot
    @logger = GameLogger.new(@bot, @boss)
    @attacker = nil
  end

  def sub_event(attr)
    @logger.sub_log(attr)
    amount = sub_damage_or_heal(attr[:plan])
    if @boss.name == 'No boss yet!'
      new_boss(attr[:username])
    elsif attr[:username] == @boss.name
      heal_boss(amount)
    else
      @attacker = attr[:username]
      attack_boss(amount)
      return unless @boss.current_hp <= 0
      @logger.kill_log(@attacker)
      new_boss(attr[:username])
    end
  end

  def bits_event(attr)
    @logger.bits_log(attr)
    amount = bits_damage_or_heal(attr[:amount].to_i)
    if @boss.name == 'No boss yet!'
      new_boss(attr[:username])
    elsif attr[:username] == @boss.name
      heal_boss(amount)
    else
      @attacker = attr[:username]
      attack_boss(amount)
      return unless @boss.current_hp <= 0
      @logger.kill_log(@attacker)
      new_boss(attr[:username])
    end
  end

  def update_from_dashboard(attr)
    dashboard_new_boss(attr) unless attr[:name] == @boss.name
    dashboard_current_hp(attr) unless attr[:current_hp] == @boss.current_hp
    dashboard_max_hp(attr) unless attr[:max_hp] == @boss.max_hp
    dashboard_current_shield(attr) unless attr[:current_shield] == @boss.current_shield
    dashboard_max_shield(attr) unless attr[:max_shield] == @boss.max_shield
    ActionCable.server.broadcast(
      "dashboard_#{@bot.id}",
      html: ApplicationController.renderer.render(partial: 'dashboard/bosses/boss_form', locals: { boss: @boss }, layout: false)
    )
  end

  private

  def dashboard_new_boss(attr)
    @boss.update(name: name!(attr[:name]), avatar: boss_avatar!(attr[:name]))
  end

  def dashboard_current_hp(attr)
    dashboard_current_shield(attr) unless attr[:current_shield] == @boss.current_shield
    @boss.update(current_hp: attr[:current_hp])
  end

  def dashboard_max_hp(attr)
    @boss.update(max_hp: attr[:max_hp])
  end

  def dashboard_current_shield(attr)
    @boss.update(current_shield: attr[:current_shield])
  end

  def dashboard_max_shield(attr)
    @boss.update(max_shield: attr[:max_shield])
  end

  def name!(name)
    @boss.name = name
  end

  def find_avatar(name)
    api_call = RestClient.get("https://api.twitch.tv/kraken/channels/#{name}?client_id=#{ENV['TWITCH_CLIENT_ID']}")
    parsed_api_call = JSON.parse(api_call)
    parsed_api_call['logo']
  end

  def boss_avatar!(name)
    @boss.avatar = find_avatar(name)
  end

  def reset_hp
    if @boss.name == 'No boss yet!'
      @boss.max_hp = @bot.boss_min_hp
      @boss.current_hp = @boss.max_hp
      @boss.max_shield = @boss.max_hp
    elsif @boss.max_hp >= @bot.boss_min_hp && @boss.max_hp <= (@bot.boss_max_hp - @bot.boss_hp_step)
      @boss.max_hp += @bot.boss_hp_step
      @boss.current_hp = @boss.max_hp
      @boss.max_shield = @boss.max_hp
    elsif @boss.max_hp >= @bot.boss_max_hp
      @boss.max_hp = @bot.boss_min_hp
      @boss.current_hp = @boss.max_hp
      @boss.max_shield = @boss.max_hp
    end
  end

  def new_boss(name)
    reset_hp
    name!(name)
    boss_avatar!(name)
    @logger.new_boss_log
    update_boss
  end

  def sub_damage_or_heal(plan)
    case plan
    when 'Prime' then @bot.sub_prime_modifier
    when '1000' then @bot.sub_five_modifier
    when '2000' then @bot.sub_ten_modifier
    when '3000' then @bot.sub_twenty_five_modifier
    end
  end

  def bits_damage_or_heal(amount)
    amount * @bot.bits_modifier
  end

  def attack_shield(damages)
    if damages > @boss.current_shield
      new_damages = damages - @boss.current_shield
      @boss.current_shield = 0
      damages_to_log = @boss.current_shield
    else
      new_damages = 0
      @boss.current_shield -= damages
      damages_to_log = damages
    end
    update_shield
    @logger.dmg_shield_log(@attacker, damages_to_log)
    new_damages
  end

  def add_shield(amount)
    if @boss.current_shield + amount <= @boss.max_shield
      @boss.current_shield += amount
      @logger.add_shield_log(amount)
    else
      previous_shield = @boss.current_shield
      @boss.current_shield = @boss.max_shield
      @logger.add_shield_log(@boss.current_shield - previous_shield)
    end
    update_shield
  end

  def attack_boss(amount)
    damages = amount
    @logger.attack_log(@attacker, damages)
    damages = attack_shield(damages) if @boss.current_shield.positive?
    return unless damages.positive?
    @boss.current_hp -= damages
    @boss.current_hp = 0 if @boss.current_hp.negative?
    @logger.dmg_hp_log(@attacker, damages)
    update_current_hp
  end

  def heal_boss(amount)
    if @boss.current_hp < @boss.max_hp
      if @boss.current_hp + amount > @boss.max_hp
        add_shield_after_heal(amount)
      else
        @boss.current_hp += amount
        @logger.heal_hp_log(amount)
        update_current_hp
      end
    else
      add_shield(amount)
    end
  end

  def add_shield_after_heal(heal)
    new_shield = (@boss.current_hp + heal) - @boss.max_hp
    previous_current_hp = @boss.current_hp
    @boss.current_hp = @boss.max_hp
    @logger.heal_hp_log(@boss.current_hp - previous_current_hp)
    update_current_hp
    add_shield(new_shield)
  end

  def update_current_hp
    @boss.update(current_hp: @boss.current_hp)
  end

  def update_shield
    @boss.update(current_shield: @boss.current_shield)
  end

  def update_boss
    @boss.update(
      name: @boss.name,
      current_hp: @boss.current_hp,
      max_hp: @boss.max_hp,
      current_shield: 0,
      max_shield: @boss.max_hp,
      avatar: @boss.avatar
    )
  end
end
