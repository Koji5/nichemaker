class GanttsController < ApplicationController
  def index
    @niche = Niche.find(params[:niche_id])
    @gantts = GanttPresenter.new(params[:niche_id]).gantts_to_hashes
  end
end
