class Movie
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nome, type: String
  field :duracao, type: Integer
  field :data_lancamento, type: Date
  field :classificacao, type: String
  field :sinopse, type: String

  attr_accessor :poster_index
  embeds_many :movie_photos
  embeds_many :people, class_name: "MoviePerson"
  has_and_belongs_to_many :genres
  accepts_nested_attributes_for :people, allow_destroy: true
end
