class Artist < ApplicationRecord
  belongs_to :genre
  has_many :albums

  validates :genre, presence: true
end
