class Movie
  include Mongoid::Document
  include Mongoid::Timestamps
  field :nome, type: String
  field :duracao, type: Integer
  field :data_lancamento, type: Date
  field :classificacao, type: String
  field :sinopse, type: String
end
