class Album < ApplicationRecord
  belongs_to :genre
  belongs_to :artist
  has_one_attached :cover_image

  validates :genre, presence: true
  validates :artist, presence: true
end
