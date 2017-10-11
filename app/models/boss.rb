class Boss < ApplicationRecord
  include TokenConcern

  belongs_to :bot

  validates :name,
            :current_hp,
            :max_hp,
            :current_shield,
            :max_shield,
            presence: true
  validates :current_hp,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: :max_hp
            },
            if: :max_hp
  validates :max_hp,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: :current_hp
            },
            if: :current_hp
  validates :current_shield,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: :max_shield
            },
            if: :max_shield
  validates :max_shield,
            numericality: { only_integer: true, equal_to: :max_hp },
            if: :max_hp

  after_update :broadcast_to_cable

  scope :find_boss, ->(id) { find_by(id: id) }

  private

  def broadcast_from_dashboard
    ActionCable.server.broadcast(
      "boss_#{bot.id}",
      boss_name: name,
      boss_current_hp: current_hp,
      boss_max_hp: max_hp,
      boss_current_shield: current_shield,
      boss_max_shield: max_shield,
      boss_avatar: avatar,
      dashboard: true
    )
  end

  def broadcast_to_cable
    if current_hp_was_supp_current_hp_and_nothing_changed
      damage_boss
    elsif current_hp_was_less_current_hp_and_nothing_changed
      heal_boss
    elsif current_shield_was_less_current_shield_and_current_hp_eq_max_hp
      add_current_shield
    elsif current_shield_was_supp_current_shield_and_nothing_changed
      damage_current_shield
    elsif name_not_changed_and_max_shield_or_max_hp_not_changed
      change_max_shield_hp_from_dashboard
    elsif name_changed_and_nothing_else
      change_name_from_dashboard
    elsif everything_changed
      new_boss
    end
  end

  def current_hp_was_supp_current_hp_and_nothing_changed
    current_hp_was > current_hp &&
      !name_changed? &&
      !max_hp_changed? &&
      !max_shield_changed?
  end

  def current_hp_was_less_current_hp_and_nothing_changed
    current_hp_was < current_hp &&
      !name_changed? &&
      !max_hp_changed? &&
      !max_shield_changed?
  end

  def current_shield_was_less_current_shield_and_current_hp_eq_max_hp
    current_shield_was < current_shield &&
      current_hp == max_hp &&
      !max_hp_changed? &&
      !max_shield_changed?
  end

  def current_shield_was_supp_current_shield_and_nothing_changed
    current_shield_was > current_shield &&
      !max_hp_changed? &&
      !max_shield_changed?
  end

  def name_not_changed_and_max_shield_or_max_hp_not_changed
    !name_changed? &&
      (max_shield_changed? || max_hp_changed?)
  end

  def name_changed_and_nothing_else
    name_changed? &&
      !current_hp_changed? &&
      !max_hp_changed? &&
      !current_shield_changed? &&
      !max_shield_changed?
  end

  def everything_changed
    name_changed? &&
      current_hp_changed? &&
      max_hp_changed? &&
      max_shield_changed?
  end

  def change_max_shield_hp_from_dashboard
    ActionCable.server.broadcast(
      "boss_#{bot.id}",
      boss_max_hp: max_hp,
      boss_max_shield: max_shield,
      max_shield_hp_from_dashboard: true
    )
  end

  def change_name_from_dashboard
    ActionCable.server.broadcast(
      "boss_#{bot.id}",
      boss_name: name,
      boss_avatar: avatar,
      name_from_dashboard: true
    )
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
