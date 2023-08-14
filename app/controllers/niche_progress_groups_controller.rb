class NicheProgressGroupsController < ApplicationController
  def fetch_niche_progress_tasks
    niche_progress_group = NicheProgressGroup.find(params[:niche_progress_group_id])
    niche_progress_tasks = NicheProgressTask.where(niche_progress_group_id: niche_progress_group.id)

    render json: niche_progress_tasks
  end
end
