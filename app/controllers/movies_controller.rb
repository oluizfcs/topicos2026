class MoviesController < ApplicationController
  def show
    @movie = Movie.find(params[:id])

    @elenco = @movie.people.select{ |mp| mp.tipo == "ator" }.map do |mp|
      {
        title: mp.person.nome,
        subtitle: "Como: #{mp.papel}",
        obj: mp.person,
        img: mp.person.photos[0]&.image_url
      }
    end
    
    @reviews = @movie.reviews.includes(:user)

    if user_signed_in?
      @review = @reviews.find_or_initialize_by(user_id: current_user.id)

      @reviews = @reviews.filter { |r| r.id != @review.id }
    end
  end
end
