class PostsController < ApplicationController

  def edit
  end

  def new
    @post = Post.new
    @niche = Niche.find(params[:niche_id])
    get_data
  end

  def create
    binding.pry
    @post = Post.new(post_params)
    @niche = Niche.find(params[:niche_id])
    if @post.save
      save_post_parameters
      save_progress_rates
      redirect_to niche_post_path(@niche.id, @post)
    else
      get_data
      render :new
    end
  end

  def show
  end

  private

  def get_data
    @niche_progress_groups = NicheProgressGroup.where(niche_id: params[:niche_id]).order(:name)
    @niche_progress_tasks = NicheProgressTask.where(niche_progress_group_id: @niche_progress_groups.first.id).order(:name)
    @niche_parameters = NicheParameter.where(niche_id: params[:niche_id]).order(:name)
    @post_parameter = PostParameter.new
  end

  def save_post_parameters
    post_parameter_params = params[:post_parameters]
    post_parameter_params.each do |post_parameter_param|
      post_parameter = PostParameter.new(post_parameter_param.permit(:niche_parameter_id, :value))
      post_parameter.post_id = @post.id
      post_parameter.save
    end
  end

  def save_progress_rates
    progress_rate = ProgressRate.new(progress_rate_params)
    progress_rate.save
  end

  def post_params
    params.permit(
      :title,
      :content,
      :posted_at,
      :niche_id,
      {images: []}
    ).merge(user_id: current_user.id)
  end

  def progress_rate_params
    params.permit(:rate, :niche_progress_task_id).merge(post_id: @post.id)
  end
end
