class NicheProgressGroupsController < ApplicationController

  def update
    @niche_progress_group = NicheProgressGroup.find(params[:id])
    if @niche_progress_group.update(niche_progress_group_params)
      render json: { message: "変更しました" }, status: :ok
    else
      render json: @niche_progress_group.errors, status: :unprocessable_entity
    end
  end

  def create
    @niche_progress_group = NicheProgressGroup.new(niche_progress_group_params)
    if @niche_progress_group.save
      render json: @niche_progress_group #, status: :created
    else
      render json: @niche_progress_group.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @niche_progress_group = NicheProgressGroup.find(params[:id])
    if @niche_progress_group.destroy
      render json: { message: "削除しました" }, status: :ok
    else
      render json: @niche_progress_group.errors, status: :unprocessable_entity
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
end
