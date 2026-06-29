class Person
  include Mongoid::Document
  include Mongoid::Timestamps

  field :cpf, type: String
  field :nome, type: String
  field :data_nascimento, type: Date
  field :biografia, type: String
  field :genero, type: String
  field :nacionalidade, type: String
  
  embeds_many :photos, class_name: "PersonPhoto", cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true

  validates :nome, presence: true
end
