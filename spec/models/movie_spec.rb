require 'rails_helper'

RSpec.describe Movie, type: :model do
  let(:movie) { build(:movie, :with_photos) }

  describe "validations" do
    it "has valid attributes" do
      expect(movie).to be_valid
    end

    it { is_expected.to validate_presence_of(:nome) }
    it { is_expected.to validate_presence_of(:duracao) }
    it { is_expected.to validate_presence_of(:data_lancamento) }
    it { is_expected.to validate_presence_of(:classificacao) }
    it { is_expected.to validate_presence_of(:movie_photos) }

    it { is_expected.to validate_inclusion_of(:classificacao).to_allow(Movie::CLASSIFICACOES) }
    it { is_expected.to validate_numericality_of(:duracao).to_allow(:only_integer => true, :greater_than => 0) }
  end
    
  describe "#display_duracao" do
    it "converts minutes into readable format" do
      expect(movie.display_duracao).to eq("2h 5m")
    end

    context "when duracao is less than an hour" do
      let(:short_movie) { Movie.new(duracao: 45) }

      it "only shows minutes" do
        expect(short_movie.display_duracao).to eq("45m")
      end
    end

    context "when duracao is multiple of 60" do
      let(:short_movie) { Movie.new(duracao: 120) }

      it "only shows hours" do
        expect(short_movie.display_duracao).to eq("2h")
      end
    end
  end

  describe "#nota" do
    it "returns 0 when movie has no reviews" do
      expect(movie.nota).to eq(0)
    end
  end
end
