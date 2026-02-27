class PartenairesController < ApplicationController
  layout 'voter'
  def index
    @partenaires = Partenaire.ordered
  end

  def show
    @partenaire = Partenaire.find(params[:id])
  end
end
