class NicheProgressTasksController < ApplicationController

  def create
    niche_progress_task = NicheProgressTask.new(niche_progress_task_params)
    # 日付情報を追加
    niche_progress_task.start = Date.parse(params[:niche_progress_task][:start])
    niche_progress_task.end = Date.parse(params[:niche_progress_task][:end])

    if niche_progress_task.save
      create_render()
    else
      render json: niche_progress_task.errors, status: :unprocessable_entity
    end
  end

  def update
    niche_progress_task = NicheProgressTask.find(params[:id])
    update_params = niche_progress_task_params.to_h
    # 日付情報を追加
    update_params[:start] = Date.parse(params[:niche_progress_task][:start])
    update_params[:end] = Date.parse(params[:niche_progress_task][:end])

    if niche_progress_task.update(update_params)
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
    params.require(:niche_progress_task).permit(:name, :niche_progress_group_id, :start, :end)
  end

  def create_render
    niche_progress_groups = NicheProgressGroup.by_niche_id(params[:niche_id])
    niche_progress_tasks = NicheProgressTask.by_group_ids(niche_progress_groups.pluck(:id))
  
    render json: niche_progress_tasks
  end

end
