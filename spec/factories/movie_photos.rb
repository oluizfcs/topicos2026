FactoryBot.define do
  images = Dir.glob(Rails.root.join('lib', 'seeds', 'images', '*.{jpg,jpeg,png}'))

  factory :movie_photo do
    is_poster { false }
    image { File.open(images.sample) }
  end
end
