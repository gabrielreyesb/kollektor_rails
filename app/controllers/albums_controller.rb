
require 'faraday'
require 'faraday_middleware'
require 'open-uri'

class AlbumsController < ApplicationController
  before_action :set_album, only: %i[ show edit update destroy ]
  layout 'crud', only: [:index, :new, :edit] 

  def index
    @albums = Album.all
  end

  def home
    @genres = Genre.all
    @albums = if params[:genre] && params[:artist]
                Album.where(genre_id: params[:genre], artist_id: params[:artist])
              elsif params[:genre]
                Album.where(genre_id: params[:genre])
              elsif params[:artist]
                Album.where(artist_id: params[:artist])
              else
                Album.all
              end
    @albums = @albums.order(year: :asc).limit(5)
  end
    
  def show
  end

  def new
    @album = Album.new
    @genres = Genre.all
    @artists = Artist.all
  end

  def edit
    @genres = Genre.all
    @artists = Artist.all
    @album = Album.find(params[:id])
  end

  def create
    @album = Album.new(album_params)
    @genres = Genre.all
    @artists = Artist.all

    artist_id = album_params[:artist_id]
    if artist_id.present?
      artist = Artist.find(artist_id)
      success = fetch_album_cover(@album.name, artist.name, 'tmp/cover.jpg')

      if success
        @album.cover_image.attach(io: File.open('tmp/cover.jpg'), filename: 'cover.jpg')
      else
        @album.errors.add(:cover_image, "No se pudo encontrar la portada en MusicBrainz")
      end
    end

    respond_to do |format|
      if @album.save
        format.html { redirect_to album_url(@album), notice: "El album fue creado correctamente" }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to album_url(@album), notice: "El album fue actualizado correctamente" }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @album.destroy!
    respond_to do |format|
      if @album.destroy
        format.html { redirect_to albums_url}
        format.json { head :no_content }
      else
        format.html { render :destroy, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_album
      @album = Album.find(params[:id])
      redirect_to albums_path, alert: "Album not found" if @album.nil?
    end

    def album_params
      params.require(:album).permit(:name, :year, :genre_id, :artist_id, :cover_image, :comments)
    end

    def fetch_album_cover(album_title, artist_name, download_path)
      search_url = "https://musicbrainz.org/ws/2/release/?query=release:\"#{URI.encode_www_form_component(album_title)}\" AND artist:\"#{URI.encode_www_form_component(artist_name)}\"&fmt=json"
      
      # Ejemplo de búsqueda directa
      # https://musicbrainz.org/ws/2/release/?query=release:RUSh%20AND%20artist:Rush

      response_mbid = Faraday.get(search_url)
    
      if response_mbid.success?
        json_data = JSON.parse(response_mbid.body)
        if json_data["releases"].is_a?(Array) && !json_data["releases"].empty?
          release_mbid = json_data["releases"][0]["id"]
          logger.info "Release MBID: #{release_mbid}"
        else
          logger.error "No releases found for: #{album_title} by #{artist_name}"
          return false
        end
        
        cover_url = "https://coverartarchive.org/release/#{release_mbid}/front"
        begin
          File.open(download_path, "wb") do |file|
            logger.info "-----------------------------------"
            logger.info "Descargando archivo"
            logger.info "-----------------------------------"
            file.write URI.open(cover_url).read 
          end
          logger.info "Cover art downloaded to #{download_path}"
          return true
        
        rescue OpenURI::HTTPError => e
          logger.error "Error fetching cover art (status #{e.io.status[0]}): #{cover_url}"
          return false
        end
      end
    end

  def set_genres_and_artists
    @genres = Genre.all
    @artists = Artist.all
  end

end
