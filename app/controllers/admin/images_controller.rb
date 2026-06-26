class Admin::ImagesController < ApplicationController
  before_action :require_admin

  def destroy_from_movie
    image_id = params[:image_id]
    
    photo = Movie.find(params[:movie_id]).movie_photos.find(image_id)

    if photo.destroy
      render turbo_stream: turbo_stream.remove("img-container-#{image_id}")
    else
      head :unprocessable_entity
    end
  end
end
