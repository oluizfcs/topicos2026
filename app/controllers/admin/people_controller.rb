class Admin::PeopleController < ApplicationController
  before_action :require_admin
  before_action :set_person, only: %i[ show edit update destroy ]

  # GET /people
  def index
    @people = Person.all
  end

  # GET /people/1
  def show
    movies = Movie.where("people.person_id" => @person.id)
    
    @credits = movies.flat_map do |movie|
      movie.people.select { |mp| mp.person_id == @person.id }.map do |mp|
        {
          tipo: mp.tipo,
          title: movie.nome,
          subtitle: mp.tipo == "ator" ? "Como: #{mp.papel}" : nil,
          obj: movie,
          img: movie.poster.image_url
        }
      end
    end.group_by { |credit| credit[:tipo] }
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  def create
    @person = Person.new(person_params.except(:movies))

    sync_movie_people(@person, person_params[:movies])

    params.dig(:person, :photos)&.each do |photo|
      next if photo.blank?
      @person.photos.build(image: photo)
    end

    if @person.save
      redirect_to [:admin, @person], notice: "Pessoa criada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /people/1
  def update
    sync_movie_people(@person, person_params[:movies])

    params.dig(:person, :photos)&.each do |photo|
      next if photo.blank?
      @person.photos.build(image: photo)
    end

    if @person.update(person_params.except(:movies))
      redirect_to [:admin, @person], notice: "Pessoa atualizada com sucesso.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /people/1
  def destroy
    @person.destroy!
    Movie.where("people.person_id" => @person.id).each do |m|
      m.people.select { |mp| mp.person_id == @person.id }.each(&:destroy)
    end
    
    redirect_to admin_people_url, notice: "Pessoa excluída com sucesso.", status: :see_other
  end

  def buscar
    termo = Regexp.escape(params[:q].squish)
    movie_id = params[:movie_id]

    if termo.size < 2 
      return render json: []
    end
    
    pessoas = Person.where(nome: Regexp.new(termo, Regexp::IGNORECASE))
                    .limit(8)
                    .only(:id, :nome, :photos)

    movie = Movie.where(id: movie_id).first

    response_data = pessoas.map do |p|
      vinculos = []

      if movie.present?
        
        if movie.people.where(person_id: p.id, tipo: "ator").exists?
          vinculos << "ator"
        end
        
        if movie.people.where(person_id: p.id, tipo: "diretor").exists?
          vinculos << "diretor"
        end
        
        if movie.people.where(person_id: p.id, tipo: "produtor").exists?
          vinculos << "produtor"
        end
        
        if movie.people.where(person_id: p.id, tipo: "escritor").exists?
          vinculos << "escritor"
        end
      end

      {
        id: p.id.to_s,
        nome: p.nome,
        foto: p.photos[0]&.image_url,
        vinculos: vinculos
      }
    end

    render json: response_data
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(
        :cpf, :nome, :data_nascimento,
        :biografia, :genero, :nacionalidade,
        photos_attributes: [:id, :image, :_destroy],
        movies: [:id, :movie_id, :tipo, :papel, :_destroy]
      )
    end

    def sync_movie_people(person, movies)
      movies&.each_value do |mp|
        movie = Movie.find(mp["movie_id"])
        
        if mp[:_destroy] == "1"
          movie.people.find(mp[:id]).destroy!
          next
        end

        vinculo_ja_existe = movie.people.any? { |mp_old| mp_old.person_id == person.id && mp_old.tipo == mp[:tipo] }

        if vinculo_ja_existe
          movie.people.where(tipo: mp[:tipo]).first.update(
            tipo: mp[:tipo],
            papel: mp[:tipo] == "ator" ? mp[:papel] : nil
          )
        else
          movie.people.create!(
            person: person,
            tipo: mp[:tipo],
            papel: mp[:tipo] == "ator" ? mp[:papel] : nil
          )
        end
      end
    end
end
