class PostNewForm
  include ActiveModel::Model

  attr_accessor(
    :title,
    :images,
    :content,
    :posted_at,
    :niche_progress_group_id,
    :niche_progress_task_id,
    :rate,
    :post_parameter_params,
    :niche_id,

    :niche,
    :niche_progress_groups,
    :niche_progress_tasks,
    :niche_parameters,
    :post_parameter,

    :post_id,
    :user_id,
    :new
  )

  # バリデーションの設定
  with_options presence: true do
#    validates :niche
    validates :title
    validates :posted_at
    validates :niche_id
    validates :user_id
  end

  # 初期化
  def initialize(params = {})
    if params[:new]
#      niche_id = params[:niche_id]
#      self.niche_title = Niche.find(params[:niche_id]).title
      self.niche = Niche.find(params[:niche_id])
      self.niche_progress_groups = NicheProgressGroup.where(niche_id: params[:niche_id]).order(:name)
      self.niche_parameters = NicheParameter.where(niche_id: params[:niche_id]).order(:name)
      self.post_parameter = PostParameter.new
      first_group = niche_progress_groups&.first
      if first_group
        self.niche_progress_tasks = NicheProgressTask.where(niche_progress_group_id: first_group).order(:name)
      end
    end
    super(params)
  end

  # 保存
  def save
    ActiveRecord::Base.transaction do

      # Postの保存
      post = Post.create!(
        title: title, 
        content: content,
        posted_at: posted_at,
        niche_id: niche_id,
        user_id: user_id
      )
      self.post_id = post.id

      # ActiveStorageでの保存
      post.images.attach(images)

      # PostParameterの保存
      filtered_post_parameter_params.each do |post_parameter_param|
        PostParameter.create!(
          niche_parameter_id: post_parameter_param[:niche_parameter_id],
          value: post_parameter_param[:value],
          post_id: post_id
        )
      end

      # ProgressRateの保存
      if rate
         ProgressRate.create!(
          rate: rate,
          niche_progress_task_id: niche_progress_task_id,
          post_id: post_id
        )
      end

    end
  end

  private

  def filtered_post_parameter_params
    return [] unless self.post_parameter_params
    self.post_parameter_params.select { |param| param[:value].present? }.map { |param| param.slice(:niche_parameter_id, :value) }
  end
end
