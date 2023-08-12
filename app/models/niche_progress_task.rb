class NicheProgressTask < ApplicationRecord
  has_many :progress_rates, dependent: :destroy
  belongs_to :niche_progress_group
end
