class PostsController < ApplicationController

  def edit
  end

  def new
    @post = Post.new
    @niche = Niche.find(params[:niche_id])
  end

  def show
  end
end
