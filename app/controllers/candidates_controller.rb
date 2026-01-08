class CandidatesController < ApplicationController
  layout 'voter'
  def index
    if params[:query].present?
      @candidates = Candidate.search_by_keywords(params[:query])
    else
      @candidates = Candidate.all
    end
  end

  def show
        @candidate = Candidate.find(params[:id])

  end
end
