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
end
