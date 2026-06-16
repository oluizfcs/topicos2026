class Studio
  include Mongoid::Document
  include Mongoid::Timestamps
  field :nome, type: String
  field :local, type: String
end
