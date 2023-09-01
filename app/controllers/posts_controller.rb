class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new, :edit, :update]

  def new
    @niche = Niche.find(params[:niche_id])
    @post_form = PostNewForm.new(niche_id: params[:niche_id], new: true)
  end

  def create
    @post_form = PostNewForm.new(post_new_form_params)
    if @post_form.valid?
      @post_form.save
      redirect_to niche_post_path(@post_form.niche_id, @post_form.post_id)
    else
      render :new
    end
  end

  def show
    post = Post.find(params[:id])
    @niche = Niche.find(params[:niche_id])
    @post_presenter = PostPresenter.new(post).to_h
  end

  def edit
    post = Post.find(params[:id])
    @post_form = PostEditForm.new(edit_attributes(post))
  end

  def update
    @post_form = PostEditForm.new(post_edit_form_params)
    if @post_form.valid?
      @post_form.save
      redirect_to niche_post_path(@post_form.niche_id, @post_form.id)
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
      :user_id,
      :niche_id
    ).merge(images: post.images, edit: 'edit')
  end

  def post_new_form_params
    params.require(:post_new_form).permit(
      :title,
      :content,
      :posted_at,
      :niche_id,
      :niche_progress_group_id,
      :niche_progress_task_id,
      :rate,
      post_parameter_params: [:niche_parameter_id, :value]#,
    ).merge(user_id: current_user.id, images: params[:images])
  end

  def post_edit_form_params
    params.require(:post_edit_form).permit(
      :niche_id,
      :title,
      :content,
      :posted_at,
      :niche_progress_task_id,
      :rate,
      post_parameter_params: [:niche_parameter_id, :value],
      deleted_image_ids: []
    ).merge(
      user_id: current_user.id, 
      images: params[:images],
      id: params[:id]
    )
  end
end
