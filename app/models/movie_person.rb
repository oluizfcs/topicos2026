class MoviePerson
  include Mongoid::Document

  def id
    _id.to_s
  end

  field :tipo, type: String
  field :papel, type: String

  embedded_in :movie
  belongs_to :person
end