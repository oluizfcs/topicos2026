class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  rescue_from Mongoid::Errors::DocumentNotFound, with: :render_not_found
  before_action :configure_devise_params, if: :devise_controller?

  protected

  def configure_devise_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nome, :photo])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nome, :photo])
  end

  private
  
  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Acesso restrito a administradores."
    end
  end

  def render_not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, formats: [:html]
  end
end
