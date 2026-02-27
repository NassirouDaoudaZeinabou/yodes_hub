class TemoignagesController < ApplicationController
  layout "voter"
  def index
    @temoignages = Temoignage.all
  end
end
