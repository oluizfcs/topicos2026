class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: %i[ update destroy ]

  def create
    review = Review.new(review_params)
    movie = Movie.find(review_params[:movie_id])

    unless review_params[:user_id] != current_user.id
      return redirect_to movie, alert: "Você não pode fazer isso."
    end

    if review.save
      redirect_to movie, notice: "Sua avaliação foi postada com sucesso."
    else
      redirect_to movie, alert: "Falha ao postar avaliação"
    end
  end

  def update
    if @review.update(review_params)
      redirect_back fallback_location: root_path, notice: "Avaliação atualizada com sucesso.", status: :see_other
    end
  end

  def destroy
    @review.destroy!
    redirect_back fallback_location: root_path, notice: "Avaliação excluída com sucesso.", status: :see_other
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(
      :nota, :titulo, :avaliacao,
      :movie_id, :user_id
    )
  end
end