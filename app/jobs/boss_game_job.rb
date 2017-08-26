class BossGameJob < ApplicationJob
  queue_as :default

  def perform(id, event)
    boss = BossGame.find(id)

    case event
    when 'damage_boss' then damage_boss(boss)
    when 'heal_boss' then heal_boss(boss)
    when 'add_shield' then add_shield(boss)
    when 'damage_shield' then damage_shield(boss)
    when 'new_boss' then new_boss(boss)
    end
  end

  private

  def new_boss(boss)
    ActionCable.server.broadcast(
      "boss_game_#{boss.bot.id}",
      boss_name: boss.name,
      boss_current_hp: boss.current_hp,
      boss_max_hp: boss.max_hp,
      boss_shield: boss.shield,
      boss_avatar: boss.avatar,
      new_boss: true
    )
  end

  def heal_boss(boss)
    ActionCable.server.broadcast(
      "boss_game_#{boss.bot.id}",
      boss_current_hp: boss.current_hp,
      heal: true
    )
  end

  def damage_boss(boss)
    ActionCable.server.broadcast(
      "boss_game_#{boss.bot.id}",
      boss_current_hp: boss.current_hp,
      damages: true
    )
  end

  def add_shield(boss)
    ActionCable.server.broadcast(
      "boss_game_#{boss.bot.id}",
      boss_shield: boss.shield,
      add_shield: true
    )
  end

  def damage_shield(boss)
    ActionCable.server.broadcast(
      "boss_game_#{boss.bot.id}",
      boss_shield: boss.shield,
      damage_shield: true
    )
  end
end
