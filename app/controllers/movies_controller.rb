class MoviesController < ApplicationController
  def show
    @movie = Movie.find(params[:id])

    @elenco = @movie.people.select { |mp| mp.tipo == "ator" }.map do |mp|
      {
        title: mp.person.nome,
        subtitle: "Como: #{mp.papel}",
        obj: mp.person,
        img: mp.person.photos[0]&.image_url
      }
    end

    if user_signed_in?
      @review = @movie.reviews.find_or_initialize_by(user_id: current_user.id)
    end

    reviews = @movie.reviews.includes(:user)
    reviews = reviews.where.not(id: @review.id) if @review&.persisted?
    @pagy, @reviews = pagy(reviews, count: reviews.count, limit: 5)
  end
end
