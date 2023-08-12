class NicheParameter < ApplicationRecord
  has_many :post_parameters, dependent: :destroy
  belongs_to :niche
end
