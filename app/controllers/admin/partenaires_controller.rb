class Admin::PartenairesController < ApplicationController
   before_action :authenticate_user!
  before_action :authorize_admin
  before_action :set_partenaire, only: %i[show edit update destroy]
  layout 'admin'

  def index
    @partenaires = Partenaire.ordered
  end

  def show
  end

  def new
    @partenaire = Partenaire.new
  end

  def create
    @partenaire = Partenaire.new(partenaire_params)

    if @partenaire.save
      redirect_to admin_partenaire_path(@partenaire), notice: "Partenaire créé avec succès."
    else
      flash.now[:alert] = "Impossible de créer le partenaire."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    removing = partenaire_params[:remove_image] == '1'
    new_image = partenaire_params[:image]

    if @partenaire.update(partenaire_params.except(:image, :remove_image))
      @partenaire.image.purge_later if removing && @partenaire.image.attached?
      @partenaire.image.attach(new_image) if new_image.present?

      redirect_to admin_partenaire_path(@partenaire), notice: "Partenaire mis à jour."
    else
      flash.now[:alert] = "Impossible de mettre à jour le partenaire."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @partenaire.destroy
    redirect_to admin_partenaires_path, notice: "Partenaire supprimé."
  end

  private

  def set_partenaire
    @partenaire = Partenaire.find(params[:id])
  end

  def partenaire_params
    params.require(:partenaire).permit(
      :name,
      :email,
      :phone,
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
