class Movie
  include Mongoid::Document
  include Mongoid::Timestamps
  # include ImageUploader::Attachment(:photo)

  field :nome, type: String
  field :duracao, type: Integer
  field :data_lancamento, type: Date
  field :classificacao, type: String
  field :sinopse, type: String

  # field :photo_data, type: String
  attr_accessor :poster_index
  embeds_many :movie_photos
  has_and_belongs_to_many :genres
end
