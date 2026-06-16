# frozen_string_literal: true

class MoviePhoto
  include Mongoid::Document
  include ImageUploader::Attachment(:image)
  field :image_data, type: String
  field :is_poster, type: Boolean, default: false

  embedded_in :movie
end
