class NicheProgressGroupsController < ApplicationController

  def update
    niche_progress_group = NicheProgressGroup.find(params[:id])
    if niche_progress_group.update(niche_progress_group_params)
      create_render(params[:niche_progress_group][:niche_id])
    else
      render json: niche_progress_group.errors, status: :unprocessable_entity
    end
  end

  def create
    niche_progress_group = NicheProgressGroup.new(niche_progress_group_params)
    if niche_progress_group.save
      create_render(params[:niche_progress_group][:niche_id])
    else
      render json: niche_progress_group.errors, status: :unprocessable_entity
    end
  end

  def destroy
    niche_progress_group = NicheProgressGroup.find(params[:id])
    niche_id = niche_progress_group.niche_id
    if niche_progress_group.destroy
      create_render(niche_id)
    else
      render json: niche_progress_group.errors, status: :unprocessable_entity
    end
  end

  def fetch_niche_progress_tasks
    niche_progress_group = NicheProgressGroup.find(params[:niche_progress_group_id])
    niche_progress_tasks = NicheProgressTask.where(niche_progress_group_id: niche_progress_group.id)

    render json: niche_progress_tasks
  end

  private

  def niche_progress_group_params
    params.require(:niche_progress_group).permit(:name, :niche_id)
  end

  def create_render(niche_id)
    niche_progress_groups = NicheProgressGroup.where(niche_id: niche_id).order(:name)
    niche_progress_tasks = NicheProgressTask.joins(:niche_progress_group)
    .select('niche_progress_tasks.*, niche_progress_groups.name AS group_name')
    .where(niche_progress_group_id: niche_progress_groups.pluck(:id))
    .order('niche_progress_groups.name, niche_progress_tasks.name')
    render json: {
      niche_progress_groups: niche_progress_groups,
      niche_progress_tasks: niche_progress_tasks
    }
  end
end
