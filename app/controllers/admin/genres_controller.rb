class Admin::GenresController < ApplicationController
  before_action :require_admin
  before_action :set_genre, only: %i[ show edit update destroy ]

  # GET /genres
  def index
    @genres = Genre.all
  end

  # GET /genres/1
  def show
  end

  # GET /genres/new
  def new
    @genre = Genre.new
  end

  # GET /genres/1/edit
  def edit
  end

  # POST /genres
  def create
    @genre = Genre.new(genre_params)

    if @genre.save
      redirect_to [:admin, @genre], notice: "Gênero criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /genres/1
  def update
    if @genre.update(genre_params)
      redirect_to [:admin, @genre], notice: "Gênero atualizado com sucesso.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /genres/1
  def destroy
    @genre.destroy!
    redirect_to admin_genres_url, notice: "Gênero excluído com sucesso.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_genre
      @genre = Genre.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def genre_params
      params.require(:genre).permit(:nome)
    end
end
