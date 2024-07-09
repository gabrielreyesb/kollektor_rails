class GenresController < ApplicationController
  before_action :set_genre, only: %i[ show edit update destroy ]

  def index
    @genres = Genre.all
  end
  
  def show
  end

  def new
    @genre = Genre.new
  end

  def edit
  end

  def create
    @genre = Genre.new(genre_params)
    respond_to do |format|
      if @genre.save
        if params[:genre][:genre_image].present?
          @genre.genre_image.attach(params[:genre][:genre_image])
        end
        format.html { redirect_to genre_url(@genre)}
        format.json { render :show, status: :created, location: @genre }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @genre.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @genre.update(genre_params)
        if params[:genre][:genre_image].present?
          @genre.genre_image.purge
          @genre.genre_image.attach(params[:genre][:genre_image])
        end
        format.html { redirect_to genre_url(@genre)}
        format.json { render :show, status: :ok, location: @genre }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @genre.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @genre.destroy!
    respond_to do |format|
      if @genre.destroy
        format.html { redirect_to genres_url}
        format.json { head :no_content }
      else
        format.html { render :destroy, status: :unprocessable_entity }
        format.json { render json: @genre.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_genre
      @genre = Genre.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Genre not found."
      redirect_to genres_path
    end

    def genre_params
      params.require(:genre).permit(:name)
    end
end
