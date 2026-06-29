class Genre
  include Mongoid::Document
  include Mongoid::Timestamps
  field :nome, type: String

  has_and_belongs_to_many :movies

  validates :nome, presence: true
  validates :nome, uniqueness: true
end
