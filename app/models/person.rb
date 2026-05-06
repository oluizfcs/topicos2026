class Person
  include Mongoid::Document
  include Mongoid::Timestamps
  field :cpf, type: String
  field :nome, type: String
  field :data_nascimento, type: Date
  field :biografia, type: String
  field :genero, type: String
  field :nacionalidade, type: String
end
