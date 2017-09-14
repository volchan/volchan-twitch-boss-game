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
    if @boss.name == 'No boss yet!'
      new_boss(attr[:username])
    elsif attr[:username] == @name
      heal_boss(attr[:amount].to_i)
    else
      attack_boss(attr[:amount].to_i)
      new_boss(attr[:username]) if @boss.current_hp <= 0
    end
  end

  private

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
    when 'Prime' then 500
    when '1000' then 500
    when '2000' then 1000
    when '3000' then 3000
    end
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
