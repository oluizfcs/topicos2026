class Person
  include Mongoid::Document
  include Mongoid::Timestamps
  include ImageUploader::Attachment(:photo)

  field :cpf, type: String
  field :nome, type: String
  field :data_nascimento, type: Date
  field :biografia, type: String
  field :genero, type: String
  field :nacionalidade, type: String
  field :photo_data, type: String
end
