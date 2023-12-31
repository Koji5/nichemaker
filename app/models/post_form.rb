class PostForm
  include ActiveModel::Model
  
  attr_accessor(
    :id,
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
    :post_parameters_by_niche,
    :deleted_image_ids,
    :images
  )

  with_options presence: true do
    validates :user_id
    validates :title
  end

  def initialize(params = {})
    niche_id = params[:niche_id]
    self.niche = Niche.find(niche_id)
    self.niche_progress_groups = NicheProgressGroup.where(niche_id: niche_id).order(:name)
    self.niche_parameters = NicheParameter.where(niche_id: niche_id).order(:name)
    self.post_parameter = PostParameter.new
    if params[:id]
      setup_for_edit(params)
    else
      setup_for_new
    end
    super(params)
  end

  def save
    ActiveRecord::Base.transaction do
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

  def update
    post = Post.find(post_id)
    ActiveRecord::Base.transaction do
      post.update!(
        title: title,
        content: content,
        posted_at: posted_at,
        niche_id: niche_id
      )
      # 削除される画像を処理する
      deleted_image_ids.each do |image_id|
        image = ActiveStorage::Attachment.find(image_id)
        image.purge if image.present?
      end
      # 追加される画像を処理する
      post.images.attach(images) if images.present?
    end
  end

  private
  def post_parameter_params
    return [] unless post_parameters
    post_parameters.select { |param| param[:value].present? }.map { |param| param.slice(:niche_parameter_id, :value) }
  end

  def setup_for_new
    self.niche_progress_tasks = NicheProgressTask.where(niche_progress_group_id: niche_progress_groups&.first.id)&.order(:name)
  end

  def setup_for_edit(params)
    progress_rate = ProgressRate.where(post_id: params[:id]).first
    self.rate = progress_rate&.rate
    self.niche_progress_task_id = progress_rate&.niche_progress_task_id
    self.niche_progress_group_id = NicheProgressTask.find(niche_progress_task_id)&.niche_progress_group_id
    self.niche_progress_tasks = NicheProgressTask.where(niche_progress_group_id: niche_progress_group_id).order(:name)
    self.post_parameters_by_niche = self.niche_parameters.map do |niche_parameter|
      PostParameter.find_by(niche_parameter_id: niche_parameter.id, post_id: params[:id]) || PostParameter.new(niche_parameter_id: niche_parameter.id)
    end
  end
end