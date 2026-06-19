class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  rescue_from Mongoid::Errors::DocumentNotFound, with: :render_not_found

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
