class Studio
  include Mongoid::Document
  include Mongoid::Timestamps
  field :nome, type: String
  field :local, type: String

  embeds_many :photos, class_name: "StudioPhoto"
  has_and_belongs_to_many :movies
  accepts_nested_attributes_for :photos

  validates :nome, presence: true
  validates :nome, uniqueness: true
end
