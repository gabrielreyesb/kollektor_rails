class AddGenreImageToGenres < ActiveRecord::Migration[7.1]
  def change
    add_column :genres, :genre_image, :attachment
  end
end
