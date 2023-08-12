class ProgressRate < ApplicationRecord
  belongs_to :niche_progress_task
  belongs_to :post
end
