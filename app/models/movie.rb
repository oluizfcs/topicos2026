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
  has_many :reviews, dependent: :destroy
  has_and_belongs_to_many :genres
  accepts_nested_attributes_for :people, allow_destroy: true

  def poster
    self.movie_photos.where(is_poster: true).first
  end

  def display_duracao
    horas, minutos = self.duracao.divmod(60)
    "#{horas}h #{minutos}m"
  end

  def nota
    notas = self.reviews.pluck(:nota)
    return 0 if notas.empty?
    
    average = "%.1f" % notas.reduce(:+).fdiv(notas.size)
    sprintf("%g", average)
  end
end
