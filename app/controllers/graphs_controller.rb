class GraphsController < ApplicationController
  def index
    @niche = Niche.find(params[:niche_id])
  end
end
