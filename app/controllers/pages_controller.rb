class PagesController < ApplicationController
    def home
        @genres = Genre.all || []
        @selected_genre = params[:genre]

        if @selected_genre.present?
            @albums = Album.where(genre_id: @selected_genre)
          else
            @albums = Album.all
        end

        if params[:artist] && params[:artist] != ''
            @albums = Album.where(artist_id: params[:artist])
          else
            @albums = Album.all
          end
    end

    def about
    end
end
