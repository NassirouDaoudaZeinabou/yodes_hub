class Admin::ResultsController < ApplicationController
   before_action :authenticate_user!
   before_action :authorize_admin
    layout 'admin'
  def index
    @total_votes = Vote.paid.count

    # @candidates = Candidate
    #   .left_joins(:votes)
    #   .where(votes: { status: "paid" })
    #   .group("candidates.id")
    #   .select("candidates.*, COUNT(votes.id) AS votes_count")
    #   .order("votes_count DESC")
    @candidates = Candidate
  .left_joins(:votes)                    # Joins candidates -> votes (garde ceux sans votes)
  .select("candidates.*, COUNT(votes.id) AS votes_count")
  .group("candidates.id")
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
