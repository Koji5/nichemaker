class NicheProgressTasksController < ApplicationController

  def create
    niche_progress_task = NicheProgressTask.new(niche_progress_task_params)
    if niche_progress_task.save
      create_render()
    else
      render json: niche_progress_task.errors, status: :unprocessable_entity
    end
  end

  def update
    niche_progress_task = NicheProgressTask.find(params[:id])
    if niche_progress_task.update(niche_progress_task_params)
      create_render()
    else
      render json: niche_progress_task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    niche_progress_task = NicheProgressTask.find(params[:id])
    if niche_progress_task.destroy
      create_render()
    else
      render json: niche_progress_task.errors, status: :unprocessable_entity
    end
  end

  private

  def niche_progress_task_params
    params.require(:niche_progress_task).permit(:name, :niche_progress_group_id)
  end

  def create_render()
    niche_progress_groups = NicheProgressGroup.where(niche_id: params[:niche_id]).order(:name)
    niche_progress_tasks = NicheProgressTask.joins(:niche_progress_group)
    .select('niche_progress_tasks.*, niche_progress_groups.name AS group_name')
    .where(niche_progress_group_id: niche_progress_groups.pluck(:id))
    .order('niche_progress_groups.name, niche_progress_tasks.name')
    render json: niche_progress_tasks
  end
end
