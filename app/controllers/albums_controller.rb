class AlbumsController < ApplicationController
  before_action :set_album, only: %i[ show edit update destroy ]

  def index
    @albums = Album.all
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
  end

  def create
    @album = Album.new(album_params)
    @genres = Genre.all
    @artists = Artist.all

    respond_to do |format|
      if @album.save
        format.html { redirect_to album_url(@album), notice: "Album was successfully created." }
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
        format.html { redirect_to album_url(@album), notice: "Album was successfully updated." }
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
      format.html { redirect_to albums_url, notice: "Album was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_album
      @album = Album.find(params[:id])
    end

    def album_params
      params.require(:album).permit(:name, :year, :genre_id, :artist_id, :cover_image)
    end

    def set_genres_and_artists
      @genres = Genre.all
      @artists = Artist.all
    end
end
