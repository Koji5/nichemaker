class NicheProgressTask < ApplicationRecord
  has_many :progress_rates, dependent: :destroy
  belongs_to :niche_progress_group

  attr_accessor :niche_progress_group_name

  def self.by_group_ids(group_ids)
    joins(:niche_progress_group)
      .select('niche_progress_tasks.*, niche_progress_groups.name AS group_name')
      .where(niche_progress_group_id: group_ids)
      .order('niche_progress_groups.name, niche_progress_tasks.start, niche_progress_tasks.name')
  end
end
