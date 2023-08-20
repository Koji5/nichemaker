class Post < ApplicationRecord
  has_many :post_parameters, dependent: :destroy
  has_one :progress_rate, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :niche
  has_many_attached :images
  accepts_nested_attributes_for :post_parameters, :progress_rate
  validates :images, length: { minimum: 0, maximum: 20}
end
