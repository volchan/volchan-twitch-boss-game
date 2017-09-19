class Game
  def initialize(boss)
    @boss = boss
    @bot = boss.bot
  end

  def sub_event(attr)
    amount = sub_damage_or_heal(attr[:plan])
    if @boss.name == 'No boss yet!'
      new_boss(attr[:username])
    elsif attr[:username] == @boss.name
      heal_boss(amount)
    else
      attack_boss(amount)
      new_boss(attr[:username]) if @boss.current_hp <= 0
    end
  end

  def bits_event(attr)
    amount = bits_damage_or_heal(attr[:amount].to_i)
    if @boss.name == 'No boss yet!'
      new_boss(attr[:username])
    elsif attr[:username] == @name
      heal_boss(amount)
    else
      attack_boss(amount)
      new_boss(attr[:username]) if @boss.current_hp <= 0
    end
  end

  def update_from_dashboard(attr)
    dashboard_new_boss(attr) unless attr[:name] == @boss.name
    dashboard_current_hp(attr) unless attr[:current_hp] == @boss.current_hp
    dashboard_max_hp(attr) unless attr[:max_hp] == @boss.max_hp
    dashboard_current_shield(attr) unless attr[:current_shield] == @boss.current_shield
    dashboard_max_shield(attr) unless attr[:max_shield] == @boss.max_shield
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
    if @boss.max_hp.zero?
      @boss.max_hp = @bot.boss_min_hp
      @boss.current_hp = @boss.max_hp
    elsif @boss.max_hp >= @bot.boss_min_hp && @boss.max_hp <= (@bot.boss_max_hp - @bot.boss_hp_step)
      @boss.max_hp += @bot.boss_hp_step
      @boss.current_hp = @boss.max_hp
    elsif @boss.max_hp >= @bot.boss_max_hp
      @boss.max_hp = @bot.boss_min_hp
      @boss.current_hp = @boss.max_hp
    end
  end

  def new_boss(name)
    name!(name)
    reset_hp
    boss_avatar!(name)
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
    else
      new_damages = 0
      @boss.current_shield -= damages
    end
    update_shield
    new_damages
  end

  def add_shield(amount)
    if @boss.current_shield + amount <= @boss.max_shield
      @boss.current_shield += amount
    else
      @boss.current_shield = @boss.max_shield
    end
    update_shield
  end

  def attack_boss(amount)
    damages = amount
    damages = attack_shield(damages) if @boss.current_shield.positive?
    return unless damages.positive?
    @boss.current_hp -= damages
    @boss.current_hp = 0 if @boss.current_hp.negative?
    update_current_hp
  end

  def heal_boss(amount)
    if @boss.current_hp < @boss.max_hp
      if @boss.current_hp + amount > @boss.max_hp
        add_shield_after_heal(amount)
      else
        @boss.current_hp += amount
        update_current_hp
      end
    else
      add_shield(amount)
    end
  end

  def add_shield_after_heal(heal)
    new_shield = (@boss.current_hp + heal) - @boss.max_hp
    @boss.current_hp = @boss.max_hp
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
