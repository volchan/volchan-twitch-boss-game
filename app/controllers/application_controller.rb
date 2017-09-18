class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_filter :set_user_time_zone

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_user_time_zone
    Time.zone = current_user.time_zone if user_signed_in?
  end

  def after_sign_in_path_for(resource)
    dashboard_root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username email password time_zone password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[login password password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username email password time_zone password_confirmation current_password])
  end
end
