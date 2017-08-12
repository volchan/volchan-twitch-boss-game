class BossGame < ApplicationRecord
  belongs_to :bot

  after_create :publish_on_cable
  after_update :publish_on_cable

  private

  def publish_on_cable
    ActionCable.server.broadcast(
      "boss_game_#{bot.id}",
      boss_name: name,
      boss_current_hp: current_hp,
      boss_max_hp: max_hp,
      boss_shield: shield,
      boss_avatar: avatar
    )
  end
end
