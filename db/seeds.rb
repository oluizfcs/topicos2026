puts " Wiping old database records..."
Mongoid.purge!

puts " Creating Admin User..."
User.create!(
  nome: "Admin",
  email: "admin@admin.com",
  password: "123",
  password_confirmation: "123",
  admin: true
)

puts " Generating Users..."
200.times do |i|
  User.create!(
    nome: "Usuário #{i}",
    email: "user#{i}@seed.com",
    password: "123",
    password_confirmation: "123"
  )
end

puts " Generating Genres..."
genres = [
  "Ação", "Aventura", "Comédia",
  "Drama", "Ficção Científica",
  "Terror", "Romance", "Suspense",
  "Fantasia", "Musical", "Animação"
].map do |genre_name|
  Genre.create!(nome: genre_name)
end

puts " Generating Studios..."
10.times do
  studio_name = "#{Faker::Company.name} #{[ 'Studios', 'Pictures', 'Filmes', 'Entertainment' ].sample}"

  Studio.create!(
    nome: studio_name,
    local: "#{Faker::Address.city}, #{Faker::Address.country}"
  )
end

puts " Generating Movies..."
all_users = User.all

30.times do
  FactoryBot.create(:movie, :with_photos,
    nome: Faker::Movie.title,
    data_lancamento: Faker::Date.between(from: "2000-01-01", to: "2026-01-01"),
    sinopse: Faker::Movie.quote,
    duracao: rand(80..180),
    classificacao: Movie::CLASSIFICACOES.sample,
    genre_ids: genres.sample(rand(1..3)).map(&:id),
    studio_ids: Studio.pluck(:id).sample(rand(1..2))
  ) do |movie|
    review_count = rand(0..50)
    reviewers = all_users.sample(review_count)

    reviewers.each do |user|
      nota = rand(1..5)

      review_title = case nota
      when 4..5
                      Faker::Adjective.positive.capitalize
      when 3
                      [ "Interessante", "Regular", "Ok", "Mediano" ].sample
      else
                      Faker::Adjective.negative.capitalize
      end

      Review.create!(
        movie: movie,
        user: user,
        nota: nota,
        titulo: review_title,
        avaliacao: Faker::Lorem.paragraph(sentence_count: rand(1..6))
      )
    end
  end
end

puts " Generating People with Custom Random Data..."
people_images = Dir.glob(Rails.root.join('lib', 'seeds', 'images', 'thispersondoesnotexist', '*.{jpg,jpeg,png}'))

60.times do
  Person.create!(
    nome: Faker::Name.name,
    biografia: Faker::Lorem.paragraph(sentence_count: 3),
    cpf: Faker::IdNumber.brazilian_citizen_number(formatted: true),
    data_nascimento: Faker::Date.between(from: "1970-01-01", to: "2010-01-01"),
    photos: [ PersonPhoto.new(image: File.open(people_images.sample)) ]
  )
end

puts " Linking People to Movies (Casting)..."
Movie.all.each do |movie|
  # Pick 2 to 5 random people to belong to this movie
  Person.all.sample(rand(2..5)).each do |person|
    movie.people.create!(
      person_id: person.id,
      tipo: [ "ator", "diretor", "escritor" ].sample,
      papel: Faker::Name.first_name
    )
  end
end

puts " Seeding completed successfully! Built #{Movie.count} movies and #{Person.count} people."
