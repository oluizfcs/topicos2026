class PeopleController < ApplicationController
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
end
