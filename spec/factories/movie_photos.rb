# require 'open-uri'

FactoryBot.define do
  factory :movie_photo do
    is_poster { false }
    image do
    #   URI.open("https://picsum.photos/600/800")
    # rescue StandartError
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'support', 'assets', 'placeholder.png'),
        'image/png'
      )
    end
  end
end
