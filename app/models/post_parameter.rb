class PostParameter < ApplicationRecord
  belongs_to :post
  belongs_to :niche_parameter
end
