class PostsController < ApplicationController

  def edit
  end

  def new
    @post = Post.new
    @niche = Niche.find(params[:niche_id])
    @niche_progress_groups = NicheProgressGroup.where(niche_id: params[:niche_id])
  end

  def show
  end

  private
  def post_params
    params.require(:post).permit(
      :title, :content,
      progress_rate_attributes: [:attribute_name1, :attribute_name2],
      post_parameters_attributes: [:attribute_name3, :attribute_name4]
    )
  end
end
