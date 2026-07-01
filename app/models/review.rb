class Review
  include Mongoid::Document
  include Mongoid::Timestamps
  field :nota, type: Integer
  field :titulo, type: String
  field :avaliacao, type: String

  belongs_to :user
  belongs_to :movie

  validates :movie, :user, :nota, presence: true
  validates :nota, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 5 }

  before_save :update_movie_attributes

  def update_movie_attributes
    notas = self.movie.reviews.pluck(:nota)
    return if notas.empty?

    self.movie.update(
      reviews_count: self.movie.reviews.size,
      nota: notas.reduce(:+).fdiv(notas.size
    ))
  end
end
