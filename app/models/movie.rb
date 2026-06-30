class Movie
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nome, type: String
  field :duracao, type: Integer
  field :data_lancamento, type: Date
  field :classificacao, type: String
  field :sinopse, type: String
  field :reviews_count, type: Integer, default: 0
  field :nota, type: Float, default: 0

  CLASSIFICACOES = %w[ L 10 12 14 16 18 ]

  attr_accessor :poster_index
  embeds_many :movie_photos, cascade_callbacks: true
  embeds_many :people, class_name: "MoviePerson"
  has_many :reviews, dependent: :destroy
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :studios
  accepts_nested_attributes_for :people, allow_destroy: true

  validates :nome, :duracao, :data_lancamento, :classificacao, :movie_photos, presence: true
  validates :classificacao, inclusion: { in: CLASSIFICACOES }
  validates :duracao, numericality: { only_integer: true, greater_than: 0 }

  def poster
    self.movie_photos.where(is_poster: true).first
  end

  def display_duracao
    horas, minutos = self.duracao.divmod(60)

    [].tap do |parts|
      parts << "#{horas}h" if horas > 0
      parts << "#{minutos}m" if minutos > 0 || horas.zero?
    end.join(' ')
  end

  def display_nota
    notas = self.reviews.pluck(:nota)
    return 0 if notas.empty?
    
    average = "%.1f" % notas.reduce(:+).fdiv(notas.size)
    sprintf("%g", average)
  end

  def generos limit = 0
    self.genres.limit(limit).map(&:nome).join(', ')
  end

  def estudios limit = 0
    self.studios.limit(limit).map(&:nome).join(', ')
  end
end
