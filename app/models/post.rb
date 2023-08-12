class Post < ApplicationRecord
  has_many :post_parameters, dependent: :destroy
  has_one :progress_rate, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :niche
end
