class BossGames < ApplicationController
  def create
    BossGame.create(
      bot: Bot.find(boss_game_params[:bot_id]),
      name: boss_game_params[:name],
      max_hp: boss_game_params[:max_hp],
      current_hp: boss_game_params[:current_hp],
      shield: boss_game_params[:shield],
      avatar: boss_game_params[:avatar]
    )
  end

  def update
    BossGame.update(
      bot: Bot.find(boss_game_params[:bot_id]),
      name: boss_game_params[:name],
      max_hp: boss_game_params[:max_hp],
      current_hp: boss_game_params[:current_hp],
      shield: boss_game_params[:shield],
      avatar: boss_game_params[:avatar]
    )
  end

  private

  def boss_game_params
    params.require(:boss_game).permit(:bot_id, :name, :max_hp, :current_hp, :shield, :avatar)
  end
end
