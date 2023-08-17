class NicheParametersController < ApplicationController

  def create
    niche_parameter = NicheParameter.new(niche_parameter_params)
    if niche_parameter.save
      create_render()
    else
      render json: niche_parameter.errors, status: :unprocessable_entity
    end
  end

  def update
    niche_parameter = NicheParameter.find(params[:id])
    if niche_parameter.update(niche_parameter_params)
      create_render()
    else
      render json: niche_progress_group.errors, status: :unprocessable_entity
    end
  end
  
  def destroy
    niche_parameter = NicheParameter.find(params[:id])
    if niche_parameter.destroy
      create_render()
    else
      render json: niche_progress_group.errors, status: :unprocessable_entity
    end
  end

  private

  def niche_parameter_params
    params.require(:niche_parameter).permit(:name, :unit, :niche_id)
  end

  def create_render()
    niche_parameters = NicheParameter.where(niche_id: params[:niche_id]).order(:name)
    render json: niche_parameters
  end

end
