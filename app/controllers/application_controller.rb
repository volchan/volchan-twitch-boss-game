class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  before_action :set_user_time_zone
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  # after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def set_user_time_zone
    Time.zone = current_user.time_zone if user_signed_in?
  end

  def after_sign_in_path_for(_)
    dashboard_root_path
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(root_path)
  end

  protected

  def configure_permitted_parameters
    sign_up_permit
    sign_in_permit
    account_update
  end

  private

  def sign_up_permit
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username
                                                         email
                                                         password
                                                         time_zone
                                                         password_confirmation])
  end

  def sign_in_permit
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[login
                                                         password
                                                         password_confirmation])
  end

  def account_update
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[username
                                               email
                                               password
                                               time_zone
                                               password_confirmation
                                               current_password])
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
