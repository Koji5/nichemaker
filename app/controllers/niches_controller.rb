class NichesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_niche, only: [:show, :edit, :update, :destroy]

  def index
  end

  def edit
  end

  def new
    @niche = Niche.new
  end

  def create
    @niche = Niche.new(niche_parameters)
    if @niche.save
      redirect_to niche_path(@niche)
    else
      render :new
    end
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

  def niche_parameters
    params.require(:niche).permit(
      :title,
      :info,
      :admin_name,
      :progress_setting,
      :parameter_setting,
      :tag_setting,
      :nice_setting,
      :publish_range,
      :topic_range,
      :comment_range
    ).merge(user_id: current_user.id)
  end

  def set_niche
    @niche = Niche.find(params[:id])
  end
end
