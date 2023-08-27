class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new]

  def edit
    post = Post.find(params[:id])
    @post_form = PostForm.new(edit_attributes(post).merge(images: post.images))
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

  def update
    @post_form = PostForm.new(post_form_params)
    if @post_form.valid?
      @post_form.update
      redirect_to niche_post_path(@post_form.niche_id, @post_form.post_id)
    else
      render :edit
    end
  end

  private

  def edit_attributes(post)
    post.attributes.symbolize_keys.slice(
      :id, 
      :title, 
      :content, 
      :posted_at, 
      :user_id
    ).merge(niche_id: post.niche_id)
  end

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
      images: [],
      deleted_image_ids: []
    ).merge(user_id: current_user.id, images: params[:images])
  end

end
