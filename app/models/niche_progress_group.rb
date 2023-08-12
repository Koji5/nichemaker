class NicheProgressGroup < ApplicationRecord
  has_many :niche_progress_tasks, dependent: :destroy
  belongs_to :niche
end
