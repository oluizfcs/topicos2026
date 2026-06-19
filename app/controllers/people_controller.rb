class PeopleController < ApplicationController
  def show
    @person = Person.find(params[:id])
    @movies = Movie.where("people.person_id" => @person.id)
    
    @credits = @movies.flat_map do |movie|
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

  def buscar
    termo = Regexp.escape(params[:q].squish)
    filme_id = params[:filme_id]

    if termo.size < 2 
      return render json: []
    end
    
    pessoas = Person.where(nome: Regexp.new(termo, Regexp::IGNORECASE))
                     .limit(8)
                     .only(:id, :nome)

    movie = Movie.where(id: filme_id).first

    response_data = pessoas.map do |p|
      vinculos = []

      if movie.present?
        
        if movie.people.where(person_id: p.id, tipo: "ator").exists?
          vinculos << "ator"
        end
        
        if movie.people.where(person_id: p.id, tipo: "diretor").exists?
          vinculos << "diretor"
        end
      end

      {
        id: p.id.to_s,
        nome: p.nome,
        # foto: p.foto_url,
        vinculos: vinculos
      }
    end

    render json: response_data
  end

  def show_old
    @person = Person.find(params[:id])
    credits = Movie.where("people.person_id" => @person.id)
    @card_list_ator = []
    @card_list_diretor = []
    @card_list_escritor = []
    @card_list_produtor = []

    credits.each do |movie|
      movie.people.where(person_id: @person.id).each do |movie_person|
        if movie_person.tipo == "ator"
          @card_list_ator << { title: movie.nome, subtitle: "Como: " + movie_person.papel, obj: movie }
        elsif movie_person.tipo == "diretor"
          @card_list_diretor << { title: movie.nome, obj: movie }
        elsif movie_person.tipo == "escritor"
          @card_list_escritor << { title: movie.nome, obj: movie }
        elsif movie_person.tipo == "produtor"
          @card_list_produtor << { title: movie.nome, obj: movie }
        end
      end
    end
  end
end
