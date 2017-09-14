class Boss < ApplicationRecord
  belongs_to :bot

  before_create :generate_token
  after_update :broadcast_to_cable

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Bot.exists?(token: random_token)
    end
  end

  private


  def broadcast_to_cable
    if current_hp_was > current_hp && !name_changed?
      damage_boss
    elsif current_hp_was < current_hp && !name_changed?
      heal_boss
    elsif current_shield_was < current_shield && current_hp == max_hp
      add_current_shield
    elsif current_shield_was > current_shield
      damage_current_shield
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
      boss_current_shield: current_shield,
      boss_max_shield: max_shield,
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

  def add_current_shield
    ActionCable.server.broadcast(
      "boss_#{bot.id}",
      boss_current_shield: current_shield,
      add_current_shield: true
    )
  end

  def damage_current_shield
    ActionCable.server.broadcast(
      "boss_#{bot.id}",
      boss_current_shield: current_shield,
      damage_current_shield: true
    )
  end
end
