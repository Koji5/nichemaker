class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new]

  def edit
    post = Post.find(params[:id])
    @post_form = PostForm.new({id: post.id, niche_id: post.niche_id})
  end

  def new
    @post_form = PostForm.new(niche_id: params[:niche_id])
  end

  def create
    @post_form = PostForm.new(post_form_params)
    if @post_form.valid?
      @post_form.save
      redirect_to niche_post_path(@post_form.niche_id, @post_form.post_id)
    else
      render :new
    end
  end

  def show
    post = Post.find(params[:id])
    @post_presenter = PostPresenter.new(post).to_h
  end

  private

  def post_form_params
    params.require(:post_form).permit(
      :title,
      :content,
      :posted_at,
      :niche_id,
      :niche_progress_group_id,
      :niche_progress_task_id,
      :rate,
      :post_id,
      post_parameters: [:niche_parameter_id, :value],
      images: []
      ).merge(user_id: current_user.id, images: params[:images])
  end

  def edit_post_form_params

  end
end
