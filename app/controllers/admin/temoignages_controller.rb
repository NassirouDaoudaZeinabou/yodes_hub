class Admin::TemoignagesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin
  layout "admin"
  def index
    @temoignages = Temoignage.all
  end
  def new
    @temoignage = Temoignage.new
  end
  def create
    @temoignage = Temoignage.new(temoignage_params)
    if @temoignage.save
      redirect_to admin_temoignages_path, notice: "Témoignage créé avec succès."
    else
      render :new
    end
  end
  def show
    @temoignage = Temoignage.find(params[:id])
  end
  def edit
    @temoignage = Temoignage.find(params[:id])
  end
  def update
    @temoignage = Temoignage.find(params[:id])
    if @temoignage.update(temoignage_params)    
      redirect_to admin_temoignages_path, notice: "Témoignage mis à jour avec succès."
    else
      render :edit
    end
  end
  def destroy
    @temoignage = Temoignage.find(params[:id])
    @temoignage.destroy     
    redirect_to admin_temoignages_path, notice: "Témoignage supprimé avec succès."
  end 
  

  private
  def temoignage_params 
    params.require(:temoignage).permit(:name, :texte, :image, :profil)
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
