class NicheProgressTask < ApplicationRecord
  has_many :progress_rates, dependent: :destroy
  belongs_to :niche_progress_group

  attr_accessor :niche_progress_group_name
end
