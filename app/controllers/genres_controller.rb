class GenresController < ApplicationController

  before_action :set_genre, only: %i[ show edit update destroy ]

  def index
    @genres = Genre.all
  end
  
  def show
    @genre = Genre.find(params[:id]) 
  end

  def new
    @genre = Genre.new
  end  

  def edit
    @genre = Genre.find(params[:id])
    respond_to do |format|
      format.html { render partial: "genres/form", locals: { genre: @genre } }
      format.turbo_stream { render turbo_stream: turbo_stream.update("genre_modal", partial: "genres/form", locals: { genre: @genre }) }
    end
  end

  def create
    @genre = Genre.new(genre_params)
    respond_to do |format|
      if @genre.save
        format.html { redirect_to genres_path, notice: "Genre was successfully created." }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("genre_modal", partial: "genres/form", locals: { genre: @genre }) }
      end
    end
  end

  def update
    @genre = Genre.find(params[:id])
    respond_to do |format|
      if @genre.update(genre_params)
        format.html { redirect_to genres_path, notice: "Genre was successfully updated." }
        format.turbo_stream 
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("genre_modal", partial: "genres/form", locals: { genre: @genre }) }
      end
    end
  end

  def destroy
    @genre = Genre.find(params[:id])
    @genre.destroy
    respond_to do |format|
      format.html { redirect_to genres_path, notice: "Genre was successfully destroyed." }
      format.turbo_stream
    end
  end

  private
    def set_genre
      @genre = Genre.find(params[:id])
    end

    def genre_params
      params.require(:genre).permit(:name)
    end
end
