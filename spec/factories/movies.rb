FactoryBot.define do
  factory :movie do
    nome            { "Filme de Teste" }
    duracao         { 125 }
    data_lancamento { "2020-02-20" }
    classificacao   { "12" }
    sinopse         { "lorem ipsum 123" }

    trait :with_photos do
      after(:build) do |movie|
        movie.movie_photos << build(:movie_photo, is_poster: true)
        movie.movie_photos << build(:movie_photo, is_poster: false)
        movie.movie_photos << build(:movie_photo, is_poster: false)
      end
    end
  end
end
