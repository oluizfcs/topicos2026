class Admin::PeopleController < ApplicationController
  before_action :require_admin
  before_action :set_person, only: %i[ show edit update destroy ]

  # GET /people
  def index
    @people = Person.all
  end

  # GET /people/1
  def show
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
    @person = Person.new(person_params)

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
    params.dig(:person, :photos)&.each do |photo|
      next if photo.blank?
      @person.photos.build(image: photo)
    end

    if @person.update(person_params)
      redirect_to [:admin, @person], notice: "Pessoa atualizada com sucesso.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /people/1
  def destroy
    @person.destroy!
    redirect_to admin_people_url, notice: "Pessoa excluída com sucesso.", status: :see_other
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
        photos_attributes: [:id, :image, :_destroy]
      )
    end
end
