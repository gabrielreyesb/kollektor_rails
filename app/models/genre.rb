class Genre < ApplicationRecord
    has_many :artist
    has_many :albums
    has_one_attached :genre_image
end
