class Boss < ApplicationRecord
  belongs_to :bot

  after_update :send_to_job

  private

  def send_to_job
    if current_hp_was > current_hp && !name_changed?
      damage_boss
    elsif current_hp_was < current_hp && !name_changed?
      heal_boss
    elsif shield_was < shield && current_hp == max_hp
      add_shield
    elsif shield_was > shield
      damage_shield
    elsif name_changed?
      new_boss
    end
  end

  def new_boss
    ActionCable.server.broadcast(
      "boss_#{bot.id}",
      boss_name: name,
      boss_current_hp: current_hp,
      boss_max_hp: max_hp,
      boss_shield: shield,
      boss_avatar: avatar,
      new_boss: true
    )
  end

  def heal_boss
    ActionCable.server.broadcast(
      "boss_#{bot.id}",
      boss_current_hp: current_hp,
      heal: true
    )
  end

  def damage_boss
    ActionCable.server.broadcast(
      "boss_#{bot.id}",
      boss_current_hp: current_hp,
      damages: true
    )
  end

  def add_shield
    ActionCable.server.broadcast(
      "boss_#{bot.id}",
      boss_shield: shield,
      add_shield: true
    )
  end

  def damage_shield
    ActionCable.server.broadcast(
      "boss_#{bot.id}",
      boss_shield: shield,
      damage_shield: true
    )
  end
end
