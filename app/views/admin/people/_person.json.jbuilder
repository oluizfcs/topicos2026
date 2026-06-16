json.extract! person, :id, :cpf, :nome, :data_nascimento, :biografia, :genero, :nacionalidade, :created_at, :updated_at
json.url person_url(person, format: :json)
