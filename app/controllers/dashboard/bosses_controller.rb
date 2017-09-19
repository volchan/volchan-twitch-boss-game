module Dashboard
  class BossesController < ApplicationController
    before_action :set_boss, only: :update

    def update
      respond_to do |format|
        if validate_boss
          send_to_job
          flash.now[:notice] = 'Successfully updated !'
          format.js { render 'dashboard/bosses/update' }
        else
          format.json { render json: @boss.errors, status: :unprocessable_entity }
          format.js { render layout: false, content_type: 'text/javascript' }
        end
      end
    end

    private

    def validate_boss
      boss = Boss.new(bosses_params)
      boss.bot = @boss.bot
      boss.valid?
    end

    def send_to_job
      BossGameJob.perform_later(
        { event_type: 'update from dashboard',
          name: bosses_params[:name],
          current_hp: bosses_params[:current_hp],
          max_hp: bosses_params[:max_hp],
          current_shield: bosses_params[:current_shield],
          max_shield: bosses_params[:max_shield] },
        @boss
      )
    end

    def set_boss
      @boss = Boss.find(params[:id])
    end

    def bosses_params
      params.require(:boss).permit(:name, :current_hp, :max_hp, :current_shield, :max_shield)
    end
  end
end
