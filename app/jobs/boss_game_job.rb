class BossGameJob < ApplicationJob
  queue_as :default

  def perform(attr)
    case attr[:event]
    when 'damage_boss' then damage_boss(attr)
    when 'heal_boss' then heal_boss(attr)
    when 'add_shield' then add_shield(attr)
    when 'damage_shield' then damage_shield(attr)
    when 'new_boss' then new_boss(attr)
    end
  end

  private

  def new_boss(attr)
    ActionCable.server.broadcast(
      "boss_game_#{attr[:bot_id]}",
      boss_name: attr[:name],
      boss_current_hp: attr[:current_hp],
      boss_max_hp: attr[:max_hp],
      boss_shield: attr[:shield],
      boss_avatar: attr[:avatar],
      new_boss: true
    )
  end

  def heal_boss(attr)
    ActionCable.server.broadcast(
      "boss_game_#{attr[:bot_id]}",
      boss_current_hp: attr[:current_hp],
      heal: true
    )
  end

  def damage_boss(attr)
    ActionCable.server.broadcast(
      "boss_game_#{attr[:bot_id]}",
      boss_current_hp: attr[:current_hp],
      damages: true
    )
  end

  def add_shield(attr)
    ActionCable.server.broadcast(
      "boss_game_#{attr[:bot_id]}",
      boss_shield: attr[:shield],
      add_shield: true
    )
  end

  def damage_shield(attr)
    ActionCable.server.broadcast(
      "boss_game_#{attr[:bot_id]}",
      boss_shield: attr[:shield],
      damage_shield: true
    )
  end
end
