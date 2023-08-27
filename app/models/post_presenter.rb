class PostPresenter
  def initialize(post)
    @post = post
  end

  def to_h
    # @postの全ての属性をハッシュとして取得し、キーをシンボルに変換
    post_data = @post.attributes.symbolize_keys

    post_data[:name] = @post.user&.nickname
    post_data[:niche_progress_group_name] = @post.progress_rate&.niche_progress_task&.niche_progress_group&.name
    post_data[:progress_task_name] = @post.progress_rate&.niche_progress_task&.name
    post_data[:rate] = @post.progress_rate&.rate
    post_data[:parameters] = fetch_parameters
    post_data[:images] = @post.images

    post_data
  end

  private

  def fetch_parameters
    parameters = PostParameter.joins(:niche_parameter)
    .where(post_id: @post.id)
    .select('post_parameters.value, niche_parameters.name, niche_parameters.unit')
    .order('niche_parameters.name')
    parameters.map do |parameter|
      {
        value: parameter.value,
        name: parameter.name,
        unit: parameter.unit
      }
    end
  end
end