class PostForm
  include ActiveModel::Model
  
  attr_accessor(
    :title,
    :content,
    :posted_at,
    :niche_id,
    :user_id,
    :niche_progress_group_id,
    :niche_progress_task_id,
    :rate,
    :post_parameters,
    :post_id,
    :niche,
    :niche_progress_groups,
    :niche_progress_tasks,
    :niche_parameters,
    :post_parameter,
    :images
  )

  with_options presence: true do
    validates :user_id
    validates :title
  end

  def initialize(params = {})
    if params["posted_at(1i)"]
      posted_at_params = params.slice("posted_at(1i)", "posted_at(2i)", "posted_at(3i)").values.map(&:to_i)
      posted_at = Date.new(*posted_at_params)
      params[:posted_at] = posted_at
      params.delete("posted_at(1i)")
      params.delete("posted_at(2i)")
      params.delete("posted_at(3i)")
    end
    niche_id = params[:niche_id]
    @niche = Niche.find(niche_id)
    @niche_progress_groups = NicheProgressGroup.where(niche_id: niche_id).order(:name)
    @niche_progress_tasks = NicheProgressTask.where(niche_progress_group_id: @niche_progress_groups.first.id).order(:name)
    @niche_parameters = NicheParameter.where(niche_id: niche_id).order(:name)
    @post_parameter = PostParameter.new
    super(params)
  end

  def post_parameter_params
    post_parameters.map { |param| param.slice(:niche_parameter_id, :value) }
  end

  def save
    ActiveRecord::Base.transaction do
      post = Post.create!(
        title: title, 
        content: content,
        posted_at: posted_at,
        niche_id: niche_id,
        user_id: user_id,
        images: images
      )
      self.post_id = post.id
      post_parameter_params.each do |post_parameter_param|
        PostParameter.create!(
          niche_parameter_id: post_parameter_param[:niche_parameter_id],
          value: post_parameter_param[:value],
          post_id: post_id
        )
      end
      ProgressRate.create!(
        rate: rate,
        niche_progress_task_id: niche_progress_task_id,
        post_id: post_id
      )
    end
  end
end