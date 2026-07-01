class UsersController < ApplicationController
  def index
    authenticate_user!
    return unless user_signed_in?

    @user = User.find(current_user.id)
    @reviews = Review.where(user_id: current_user.id)
    render "users/show"
  end

  def show
    @user = User.find(params[:id])
    @reviews = Review.where(user_id: @user.id)
  end
end
