class Admin::DashboardController < ApplicationController
   before_action :authenticate_user!
  before_action :authorize_admin

  layout 'admin'
  
  def index
    # Statistiques générales
    @total_candidates = Candidate.count
    @active_candidates = Candidate.where(active: true).count
    @total_votes = Vote.count
    @total_users = User.count
    @total_videos = Video.count
    @candidate_videos = Video.where(category: "candidate").count
    @emission_videos = Video.where(category: "emission").count
    
    # Votes récents (7 derniers jours)
    @recent_votes = Vote.where('created_at >= ?', 7.days.ago).count
    @votes_today = Vote.where('created_at >= ?', Date.today).count
    
    # Top candidats par votes
    @top_candidates = Candidate.left_joins(:votes)
                               .group('candidates.id')
                               .select('candidates.*, COUNT(votes.id) as votes_count')
                               .order('votes_count DESC')
                               .limit(5)
    
    # Votes par jour (pour graphique) - Utilisation de SQL natif PostgreSQL
    @votes_by_day = Vote.where('created_at >= ?', 30.days.ago)
                        .group("DATE_TRUNC('day', created_at)")
                        .count
    
    # Derniers votes
    @latest_votes = Vote.includes(:candidate)
                        .order(created_at: :desc)
                        .limit(10)
    
    # Nouveaux candidats récents
    @recent_candidates = Candidate.order(created_at: :desc).limit(5)
    
    # Nouveaux utilisateurs récents
    @recent_users = User.order(created_at: :desc).limit(5)
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
