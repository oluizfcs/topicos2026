# frozen_string_literal: true

class MoviePhoto
  include Mongoid::Document
  include ImageUploader::Attachment(:image)
  field :image_data, type: String
  field :is_poster, type: Boolean, default: false

  embedded_in :movie

  before_save :promote_image

  private

  def promote_image
    image_attacher.finalize if image_attacher.cached?
  end
end
