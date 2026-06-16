class Admin::MoviesController < ApplicationController
  before_action :require_admin
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies
  def index
    @movies = Movie.all
  end

  # GET /movies/1
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies
  def create
    @movie = Movie.new(movie_params.except(:poster_index))

    params.dig(:movie, :photos).each_with_index do |photo, i|
      next if photo.blank?
      @movie.movie_photos.build(
        image: photo,
        is_poster: i == movie_params[:poster_index].to_i
      )
    end

    if @movie.save
      redirect_to [:admin, @movie], notice: "O Filme foi criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /movies/1
  def update
    if @movie.update(movie_params)
      redirect_to [:admin, @movie], notice: "O Filme foi atualizado com sucesso.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /movies/1
  def destroy
    @movie.destroy!
    redirect_to admin_movies_url, notice: "Movie was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:nome, :duracao, :data_lancamento, :classificacao, :sinopse, :poster_index, genre_ids: [])
    end
end
