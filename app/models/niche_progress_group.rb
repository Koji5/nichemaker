class NicheProgressGroup < ApplicationRecord
  has_many :niche_progress_tasks, dependent: :destroy
  belongs_to :niche

  def self.by_niche_id(niche_id)
    where(niche_id: niche_id).order(:name)
  end
end
