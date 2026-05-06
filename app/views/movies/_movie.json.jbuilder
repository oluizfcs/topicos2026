json.extract! movie, :id, :nome, :duracao, :data_lancamento, :classificacao, :sinopse, :created_at, :updated_at
json.url movie_url(movie, format: :json)
