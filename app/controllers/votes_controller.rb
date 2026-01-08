class VotesController < ApplicationController
  before_action :set_candidate, only: [:new, :create]
   layout 'voter'

  # GET /votes/new?candidate_id=1
  def new
    @vote = Vote.new
  end

  # POST /votes
  def create
    @vote = Vote.new(vote_params)
    @vote.candidate = @candidate
    @vote.ip_address = request.remote_ip
    @vote.amount = 100 # montant fixe par vote (ex: 500 FCFA)
    @vote.status = "pending"

    if @vote.save
      # 👉 Étape suivante : redirection vers le paiement
     redirect_to ipay_fake_payment_path(@vote)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /votes/:id
  def show
    @vote = Vote.find(params[:id])
  end

  private

  def set_candidate
    @candidate = Candidate.find(params[:candidate_id])
  end

  def vote_params
    params.require(:vote).permit(:phone_number)
  end
end
