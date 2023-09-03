class NichesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_niche, only: [:show, :edit, :update, :destroy]
  before_action :move_to_index, only: [:edit, :update, :destroy]

  def index
    @niches = Niche.order(created_at: :desc).limit(9)
  end

  def edit
    @niche_progress_groups = NicheProgressGroup.by_niche_id(params[:id])
    @niche_progress_tasks = NicheProgressTask.by_group_ids(@niche_progress_groups.pluck(:id))
    @niche_parameters = NicheParameter.where(niche_id: params[:id]).order(:name)
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
    @posts = Post.where(niche_id: params[:id]).order(:posted_at)
  end

  def update
    if @niche.update(niche_parameters)
      redirect_to niche_path(params[:id])
    else
      render :edit
    end
  end

  def destroy
  end

  private

  def niche_parameters
    params.require(:niche).permit(:title, :info, :admin_name, :progress_setting, :parameter_setting, :tag_setting, :nice_setting, :publish_range, :topic_range, :comment_range)
    .merge(user_id: current_user.id)
  end

  def set_niche
    @niche = Niche.find(params[:id])
  end

  def move_to_index
    if current_user.id != @niche.user_id
      redirect_to niche_path(@niche)
    end
  end
end
