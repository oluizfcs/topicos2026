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

    params.dig(:movie, :photos)&.each_with_index do |photo, i|
      next if photo.blank?
      @movie.movie_photos.build(
        image: photo,
        is_poster: i == movie_params[:poster_index].to_i
      )
    end

    if @movie.save
      redirect_to [:admin, @movie], notice: "Filme criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /movies/1
  def update
    @movie.movie_photos.each do |p|
      if p.is_poster
        p.is_poster = false
      end
    end

    params.dig(:movie, :photos)&.each_with_index do |photo, i|
      next if photo.blank?
      @movie.movie_photos.build(
        image: photo,
        is_poster: false
      )
    end

    unless @movie.movie_photos.empty?
      poster = @movie.movie_photos[movie_params[:poster_index].to_i.clamp(0, @movie.movie_photos.size - 1)]
      poster.update(is_poster: true)
    end

    if @movie.update(movie_params.except(:poster_index))
      redirect_to [:admin, @movie], notice: "Filme atualizado com sucesso.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /movies/1
  def destroy
    @movie.destroy!
    redirect_to admin_movies_url, notice: "Filme excluído com sucesso.", status: :see_other
  end

  def buscar
    termo = Regexp.escape(params[:q].squish)
    person_id = params[:person_id]

    if termo.size < 2 
      return render json: []
    end

    movies = Movie.where(nome: Regexp.new(termo, Regexp::IGNORECASE))
                  .limit(8)
                  .only(:id, :nome, :people, :movie_photos)

    person = Person.where(id: person_id).first

    response_data = movies.map do |movie|
      vinculos = []

      if person.present?
        
        if movie.people.where(person_id: person.id, tipo: "ator").exists?
          vinculos << "ator"
        end
        
        if movie.people.where(person_id: person.id, tipo: "diretor").exists?
          vinculos << "diretor"
        end

        if movie.people.where(person_id: person.id, tipo: "produtor").exists?
          vinculos << "produtor"
        end
        
        if movie.people.where(person_id: person.id, tipo: "escritor").exists?
          vinculos << "escritor"
        end
      end

      {
        id: movie.id.to_s,
        nome: movie.nome,
        foto: movie.poster.image_url,
        vinculos: vinculos
      }
    end

    render json: response_data
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(
        :nome, :duracao, :data_lancamento,
        :classificacao, :sinopse, :poster_index,
        studio_ids: [], genre_ids: [],
        people_attributes: [:id, :person_id, :tipo, :papel, :_destroy])
    end
end
