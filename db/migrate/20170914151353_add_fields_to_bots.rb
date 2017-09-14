class AddFieldsToBots < ActiveRecord::Migration[5.0]
  def change
    add_column :bots, :sub_prime_modifier, :integer, default: 500
    add_column :bots, :sub_five_modifier, :integer, default: 500
    add_column :bots, :sub_ten_modifier, :integer, default: 1000
    add_column :bots, :sub_twenty_five_modifier, :integer, default: 3000
    add_column :bots, :bits_modifier, :integer, default: 1
  end
end
