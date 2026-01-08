class Admin::VotesController < ApplicationController
 before_action :authenticate_user!
 before_action :authorize_admin   
  before_action :set_vote, only: [:destroy]
    layout 'admin'
    def index
        @votes = Vote.order(created_at: :desc)
    end
    
    def destroy
        @vote.destroy
        redirect_to admin_votes_path, notice: "Vote supprimé avec succès."
    end
    
    private
    
    def set_vote
        @vote = Vote.find(params[:id])
    end
    private
     def authorize_admin
    return unless current_user

    if current_user.respond_to?(:admin?)
      redirect_to root_path, alert: 'Accès admin requis.' unless current_user.admin?
    elsif current_user.respond_to?(:role)
      redirect_to root_path, alert: 'Accès admin requis.' unless current_user.role == 'admin'
    end
  end
end
