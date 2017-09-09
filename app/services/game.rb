class Game
  def initialize(boss)
    @boss = boss
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
      @boss.max_hp = 1000
      @boss.current_hp = @boss.max_hp
    elsif @boss.max_hp >= 1000 && @boss.max_hp <= 4800
      @boss.max_hp += 200
      @boss.current_hp = @boss.max_hp
    elsif @boss.max_hp >= 5000
      @boss.max_hp = 1000
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
    new_damages = damages - @boss.shield
    @boss.shield -= damages - new_damages
    update_shield
    new_damages
  end

  def add_shield(amount)
    @boss.shield += amount if amount.positive? && @boss.shield < @boss.max_hp
    @boss.shield = @boss.max_hp if @boss.shield > @boss.max_hp
    update_shield
  end

  def attack_boss(amount)
    damages = amount
    damages = attack_shield(damages) if @boss.shield.positive?
    return unless damages.positive?
    @boss.current_hp -= damages
    update_current_hp
  end

  def heal_boss(amount)
    if @boss.current_hp < @boss.max_hp
      if @boss.current_hp + amount > @boss.max_hp
        add_shield_before_heal(amount)
      else
        @boss.current_hp += amount
        update_current_hp
      end
    else
      add_shield(amount)
    end
  end

  def add_shield_before_heal(heal)
    new_shield = (@boss.current_hp + heal) - @boss.max_hp
    @boss.current_hp = @boss.max_hp
    update_current_hp
    add_shield(new_shield)
  end

  def update_current_hp
    @boss.update(current_hp: @boss.current_hp)
  end

  def update_shield
    @boss.update(shield: @boss.shield)
  end

  def update_boss
    @boss.update(
      name: @boss.name,
      current_hp: @boss.current_hp,
      max_hp: @boss.max_hp,
      shield: @boss.shield,
      avatar: @boss.avatar
    )
  end
end
