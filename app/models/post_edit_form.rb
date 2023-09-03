class PostEditForm
  include ActiveModel::Model
  
  attr_accessor(
    :id, 
    :niche_id,
    :niche_title,
    :title, 
    :content, 
    :posted_at, 
    :user_id,
    :images,
    :deleted_image_ids,
    :edit,

#    :niche,
    :niche_progress_groups,
    :niche_parameters,
    :niche_progress_tasks,
    :post_parameter,
    :post_parameters_by_niche,
    :post_parameter_params,

    :rate,
    :niche_progress_task_id,
    :niche_progress_group_id,
    :post_parameter_params,
    :user_id
  )

  # バリデーションの設定
  with_options presence: true do

  end

  # 初期化
  def initialize(params = {})
    if params[:edit]
      self.niche_title = Niche.find(params[:niche_id]).title
      self.niche_progress_groups = NicheProgressGroup.where(niche_id: params[:niche_id]).order(:name)
      self.niche_parameters = NicheParameter.where(niche_id: params[:niche_id]).order(:name)
      self.post_parameter = PostParameter.new
      progress_rate = ProgressRate.where(post_id: params[:id]).first
      self.rate = progress_rate&.rate
      self.niche_progress_task_id = progress_rate&.niche_progress_task_id
      self.niche_progress_group_id = NicheProgressTask.find(niche_progress_task_id)&.niche_progress_group_id
      self.niche_progress_tasks = NicheProgressTask.where(niche_progress_group_id: niche_progress_group_id).order(:name)
      self.post_parameters_by_niche = self.niche_parameters.map do |niche_parameter|
        PostParameter.find_by(niche_parameter_id: niche_parameter.id, post_id: params[:id]) || PostParameter.new
        #(niche_parameter_id: niche_parameter.id, post_id: params[:id])
      end
    end
    super(params)
  end

  
  def save
    post = Post.find(id)
    ActiveRecord::Base.transaction do
      # Postの保存
      post.update!(
        title: title,
        content: content,
        posted_at: posted_at,
        niche_id: niche_id
      )

      # 削除される画像を処理する
      deleted_image_ids = deleted_image_ids || [] 
      deleted_image_ids.each do |image_id|
        image = ActiveStorage::Attachment.find(image_id)
        image.purge if image.present?
      end
      # 追加される画像を処理する
      post.images.attach(images) if images.present?

      # PostParameterの保存
      post_parameter_params = post_parameter_params || []
      post_parameter_params.each do |post_parameter_param|
        post_parameter = PostParameter.find_or_initialize_by(
          niche_parameter_id: post_parameter_param[:niche_parameter_id],
          post_id: post.id
        )
        post_parameter.assign_attributes(post_parameter_param)
        post_parameter.save!
      end

      # ProgressRateの保存
      progress_rate = ProgressRate.find_or_initialize_by(
        post_id: post.id
      )
      progress_rate.assign_attributes(
        rate: rate,
        niche_progress_task_id: niche_progress_task_id
      )
      progress_rate.save!
    end
  end
end