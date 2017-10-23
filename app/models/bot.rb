class Bot < ApplicationRecord
  include TokenConcern

  belongs_to :user
  has_one :boss, dependent: :destroy
  has_many :logs, dependent: :destroy

  validates :channel, presence: true, uniqueness: true
  validates :boss_max_hp,
            :boss_min_hp,
            :boss_hp_step,
            :channel,
            :sub_prime_modifier,
            :sub_five_modifier,
            :sub_ten_modifier,
            :sub_twenty_five_modifier,
            :bits_modifier,
            presence: true
  validates :boss_min_hp, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: :boss_max_hp }, if: :boss_max_hp
  validates :boss_max_hp, numericality: { only_integer: true, greater_than: :boss_min_hp }, if: :boss_min_hp
  validates :boss_hp_step, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, if: :boss_max_hp
  validates :sub_prime_modifier, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than: :sub_ten_modifier }, if: :sub_ten_modifier
  validates :sub_five_modifier, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than: :sub_ten_modifier }, if: :sub_ten_modifier
  validates :sub_ten_modifier, numericality: { only_integer: true, greater_than: :sub_five_modifier }, if: :sub_five_modifier
  validates :sub_twenty_five_modifier, numericality: { only_integer: true, greater_than: :sub_ten_modifier }, if: :sub_ten_modifier
  validates :bits_modifier, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  validate :hp_step

  scope :find_bot, ->(id) { find_by(id: id) }
  scope :find_with_user, ->(user) { includes(:boss).find_by(user: user) }

  private

  def hp_step
    return if boss_max_hp.blank?
    return if boss_hp_step <= (boss_max_hp / 2)
    errors[:boss_hp_step] << "Have to be lower or equal to half of #{boss_max_hp} !"
  end
end
