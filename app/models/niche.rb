class Niche < ApplicationRecord
  has_many :niche_progress_groups, dependent: :destroy
  has_many :niche_parameters, dependent: :destroy
  has_many :posts, dependent: :destroy
  belongs_to :user
end
