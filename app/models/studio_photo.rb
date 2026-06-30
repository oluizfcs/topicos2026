class StudioPhoto
  include Mongoid::Document
  include ImageUploader::Attachment(:image)

  embedded_in :studio

  field :image_data, type: String
end
