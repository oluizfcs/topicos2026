class HomeController < ApplicationController
  def index
  end

  def buscar
    termo = Regexp.new(Regexp.escape(params[:q].squish), Regexp::IGNORECASE)

    people = Person.where(nome: termo).or(biografia: termo)
    movies = Movie.where(nome: termo).or(sinopse: termo)

    @pessoas = people.map do |p|
      linked_movies = Movie.where("people.person_id" => p.id)
      
      roles = linked_movies.flat_map do |m|
        m.people.select { |mp| mp.person_id == p.id }.map { |mp| mp.tipo.capitalize }
      end.uniq

      {
        title: p.nome,
        subtitle: roles.empty? ? "Nenhuma participação" : roles.join(" • "),
        obj: p,
        img: p.photo_url
      }
    end

    @filmes = movies.map do |m|
      {
        title: m.nome,
        subtitle: "<i class='bi bi-star-fill'></i> #{m.nota} • #{m.generos(2)} • #{m.data_lancamento.strftime("%Y")}".html_safe,
        obj: m,
        img: m.poster.image_url
      }
    end
  end
end
