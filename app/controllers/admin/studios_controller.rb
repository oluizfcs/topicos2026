class Admin::StudiosController < ApplicationController
  before_action :require_admin
  before_action :set_studio, only: %i[ show edit update destroy ]

  # GET /studios
  def index
    @studios = Studio.all
  end

  # GET /studios/1
  def show
    @movies = Movie.where(studio_ids: @studio.id).map do |m|
      {
        title: m.nome,
        subtitle: "<i class='bi bi-star-fill'></i> #{m.display_nota} • #{m.generos(2)} • #{m.data_lancamento.strftime("%Y")}".html_safe,
        obj: m,
        img: m.poster.image_url
      }
    end
  end

  # GET /studios/new
  def new
    @studio = Studio.new
  end

  # GET /studios/1/edit
  def edit
  end

  # POST /studios
  def create
    @studio = Studio.new(studio_params)

    params.dig(:studio, :photos)&.each do |photo|
      next if photo.blank?
      @studio.photos.build(image: photo)
    end

    if @studio.save
      sync_movies(params[:studio][:movies])
      redirect_to [:admin, @studio], notice: "Estúdio criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /studios/1
  def update
    params.dig(:studio, :photos)&.each do |photo|
      next if photo.blank?
      @studio.photos.build(image: photo)
    end

    if @studio.update(studio_params)
      sync_movies(params[:studio][:movies])
      redirect_to [:admin, @studio], notice: "Estúdio atualizado com sucesso.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /studios/1
  def destroy
    @studio.destroy!
    redirect_to admin_studios_url, notice: "Estúdio excluído com sucesso.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_studio
      @studio = Studio.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def studio_params
      params.require(:studio).permit(:nome, :local)
    end

    def sync_movies(movies_params)
      movies_params&.each_value do |movie_param|
        movie = Movie.find(movie_param[:id])

        if movie_param[:_destroy] == "1"
          movie.studios.delete(@studio)
        else
          movie.studios << @studio unless movie.studio_ids.include?(@studio.id)
        end
      end
    end
end
