class HomesController < ApplicationController
  layout 'voter'
  def index
    @candidates = Candidate.order(created_at: :desc)
    @videos = Video.where(category: "candidate").order(created_at: :desc).limit(3)
    @emission_videos  = Video.where(category: "emission").order(created_at: :desc).limit(3)
    @partenaires = Partenaire.ordered
   # @total_votes = candidate.votes.paid.count

  end
end
