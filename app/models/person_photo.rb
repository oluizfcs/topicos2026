class PersonPhoto
  include Mongoid::Document
  include ImageUploader::Attachment(:image)

  embedded_in :person

  field :image_data, type: String
end
