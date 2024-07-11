
class PagesController < ApplicationController
    def home
        @genres = Genre.all
        @artists = Artist.all
        @selected_genre = params[:genre]
        @selected_artist = params[:artist]

        @albums = Album.includes(:genre, :artist)

        if @selected_genre.present? && @selected_genre != ""
          @albums = @albums.where(genre_id: @selected_genre) 
        end

        if @selected_artist.present? && @selected_artist != ""
          @albums = @albums.where(artist_id: @selected_artist)  
        end
    end

    def about
    end
end
