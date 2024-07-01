class Album < ApplicationRecord
    has_one_attached :cover_image
    belongs_to :genre
end
