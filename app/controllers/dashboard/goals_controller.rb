module Dashboard
  class GoalsController < ApplicationController
    before_action :set_goal, only: %I[update destroy pause]

    def new_sub_goal
      authorize @goal = Goal.new(g_type: 0)
      respond_to do |format|
        format.js { render :new, layout: false }
      end
    end

    def new_bits_goal
      authorize @goal = Goal.new(g_type: 1)
      respond_to do |format|
        format.js { render :new, layout: false }
      end
    end

    def create
      authorize @goal = current_user.goals.new(goal_params)
      respond_to do |format|
        if @goal.save
          flash.now[:notice] = "#{@goal.g_type.humanize} created!"
          format.js { render :create, layout: false }
        else
          flash.now[:alert] = 'Something went wrong !'
          format.json { render json: @goal.errors, status: :unprocessable_entity }
          format.js   { render :new, layout: false, content_type: 'text/javascript' }
        end
      end
    end

    def update
      respond_to do |format|
        if @goal.paused?
          flash.now[:notice] = "Can't update paused #{@goal.g_type.humanize}!"
          format.js { render :update }
        elsif @goal.update(goal_params)
          flash.now[:notice] = "#{@goal.g_type.humanize} updated!"
          format.js { render :update }
        else
          flash.now[:alert] = 'Something went wrong !'
          format.json { render json: @goal.errors, status: :unprocessable_entity }
          format.js   { render :update, layout: false, content_type: 'text/javascript' }
        end
      end
    end

    def destroy
      respond_to do |format|
        if @goal.destroy
          flash.now[:notice] = "#{@goal.g_type.humanize} deleted!"
          format.js { render :destroy }
        else
          flash.now[:alert] = 'Something went wrong !'
          format.json { render json: @goal.errors, status: :unprocessable_entity }
          format.js   { render :update, layout: false, content_type: 'text/javascript' }
        end
      end
    end

    def pause
      case @goal.status
      when 'in_progress'
        flash.now[:notice] = "#{@goal.g_type.humanize} paused!"
        @goal.paused!
      else
        flash.now[:notice] = "#{@goal.g_type.humanize} resumed!"
        @goal.in_progress!
      end
      respond_to do |format|
        format.js { render :update }
      end
    end

    private

    def set_goal
      authorize @goal = Goal.find(params[:id])
    end

    def goal_params
      params.require(:goal).permit(:title, :g_type, :required, :current)
    end
  end
end
