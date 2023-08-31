class GanttsController < ApplicationController
  def index
    @gantts = GanttPresenter.new(params[:niche_id]).gantts_to_hashes
  end
end
