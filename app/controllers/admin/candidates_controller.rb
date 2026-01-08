class Admin::CandidatesController < ApplicationController
  # Uncomment these if you have authentication / admin logic
   before_action :authenticate_user!
   before_action :authorize_admin

  before_action :set_candidate, only: %i[show edit update destroy]
  layout 'admin'

  def index
    @candidates = Candidate.order(created_at: :desc)
    @candidat_actif=Candidate.where(active: true).count
    @candidat_inactif=Candidate.where(active: false).count
  end

  def show
  end

  def new
    @candidate = Candidate.new
  end

  def create
    @candidate = Candidate.new(candidate_params)

    if @candidate.save
      redirect_to admin_candidate_path(@candidate), notice: "Candidat créé avec succès."
    else
      flash.now[:alert] = "Impossible de créer le candidat."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    removing = candidate_params[:remove_image] == '1'
    new_image = candidate_params[:image]

    if @candidate.update(candidate_params.except(:image, :remove_image))
      @candidate.image.purge_later if removing && @candidate.image.attached?
      @candidate.image.attach(new_image) if new_image.present?

      redirect_to admin_candidate_path(@candidate), notice: "Candidat mis à jour."
    else
      flash.now[:alert] = "Impossible de mettre à jour le candidat."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @candidate.destroy
    redirect_to admin_candidates_path, notice: "Candidat supprimé."
  end

  private

  def set_candidate
    @candidate = Candidate.find(params[:id])
  end

  def candidate_params
    params.require(:candidate).permit(
      :name,
      :bio,
      :video_url,
      :active,
      :image,
      :remove_image
    )
  end
   def authorize_admin
    return unless current_user

    if current_user.respond_to?(:admin?)
      redirect_to root_path, alert: 'Accès admin requis.' unless current_user.admin?
    elsif current_user.respond_to?(:role)
      redirect_to root_path, alert: 'Accès admin requis.' unless current_user.role == 'admin'
    end
  end
end
