class BossGameJob < ApplicationJob
  queue_as :default

  def perform(id)
    boss = BossGame.find(id)
    if boss.current_hp_was > boss.current_hp && !boss.name_changed?
      damage_boss(boss)
    elsif boss.current_hp_was < boss.current_hp && !boss.name_changed?
      heal_boss(boss)
    elsif boss.shield_was < boss.shield && boss.current_hp == boss.max_hp
      add_shield(boss)
    elsif boss.shield_was > boss.shield
      damage_shield(boss)
    elsif boss.name_changed?
      new_boss(boss)
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
