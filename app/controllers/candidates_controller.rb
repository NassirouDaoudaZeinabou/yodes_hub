class CandidatesController < ApplicationController
  layout 'voter'
  def index
    @ecoles = Ecole.order(:nom)

    @candidates = if params[:query].present?
      Candidate.search_by_keywords(params[:query])
    else
      Candidate.all
    end

    if params[:ecole_id].present?
      @candidates = @candidates.where(ecole_id: params[:ecole_id])
    end

    # Simple manual pagination (no extra gem required)
    per_page = (params[:per_page] || 12).to_i
    per_page = 12 if per_page <= 0
    page = params[:page].to_i
    page = 1 if page <= 0

    @total_candidates = @candidates.count
    @total_pages = (@total_candidates / per_page.to_f).ceil
    @page = page
    @per_page = per_page

    @candidates = @candidates.order(created_at: :desc).offset((page - 1) * per_page).limit(per_page)
  end

  def show
        @candidate = Candidate.find(params[:id])

  end
end
