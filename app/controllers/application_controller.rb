class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
    protected

  def after_sign_in_path_for(user)
    if user.admin? || user.role == 'admin'
      admin_dashboard_index_path  # chemin vers ton dashboard admin
    else
      root_path             # ou n'importe quelle autre page pour les utilisateurs normaux
    end
  end
end
