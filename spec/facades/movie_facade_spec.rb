require 'rails_helper'

RSpec.describe MovieFacade do

  describe 'class methods' do
    describe 'get_movie_poster(id)' do
      it 'creates a movie object and returns a poster URL when given a movie id as argument' do
      VCR.use_cassette('all_movie_data_by_id_550') do
        expect(MovieFacade.get_movie_poster(550)).to be_a(String)
      end
      end
    end

    describe 'get_movie_title(id)' do
      it 'creates a movie object and returns a title when given a movie id as argument' do
      VCR.use_cassette('all_movie_data_by_id_550') do
        expect(MovieFacade.get_movie_title(550)).to be_a(String)
      end
      end
    end
  end

  describe 'instance methods' do
    describe '#initialize' do
      it 'creates an instance of a MovieFacade object with a given id' do
        facade = MovieFacade.new(550)
        expect(facade).to be_a(MovieFacade)
      end
    end

    describe '#movie' do
      it 'returns a movie object that stores all movie data needed for show page' do
        VCR.use_cassette('all_movie_data_by_id_550') do
          movie = MovieFacade.new(550).movie

          expect(movie).to be_a(Movie)
          expect(movie.id).to be_a(Integer)
          expect(movie.title).to be_a(String)
          expect(movie.vote_average).to be_a(Float)
          expect(movie.runtime).to be_a(Integer)
          expect(movie.genres).to be_a(Array)
          expect(movie.genres.first).to be_a(String)
          expect(movie.summary).to be_a(String)
          expect(movie.poster).to be_a(String)
        end
      end
    end

    describe '#reviews' do
      it 'returns review objects that contain data for a specific movies reviews' do
        VCR.use_cassette('all_review_data_by_id_550') do
          reviews = MovieFacade.new(550).reviews

          expect(reviews).to be_a(Array)
          expect(reviews.first).to be_a(Review)

          reviews.each do |review|
            expect(review.author).to be_a(String)
            expect(review.content).to be_a(String)
          end
        end
      end
    end

    describe '#cast' do
      it 'returns cast objects that contain data for a specific movies cast members' do
        VCR.use_cassette('all_cast_data_by_id_550') do
          cast = MovieFacade.new(550).cast

          expect(cast).to be_a(Array)
          expect(cast.first).to be_a(CastMember)

          cast.each do |cast_member|
            expect(cast_member.name).to be_a(String)
            expect(cast_member.character).to be_a(String)
          end
        end
      end

      it 'returns an array of 10 cast member objects' do
        VCR.use_cassette('all_cast_data_by_id_550') do
          cast = MovieFacade.new(550).cast

          expect(cast.count).to be <= 10
        end
      end
    end

    describe 'attribute methods' do
      it 'they return movie attributes for display in the views' do
        VCR.use_cassette('all_movie_data_by_id_550') do
          facade = MovieFacade.new(550)

          expect(facade.movie_id).to be_a(Integer)
          expect(facade.movie_title).to be_a(String)
          expect(facade.movie_vote_average).to be_a(Float)
          expect(facade.movie_runtime).to be_a(Integer)
          expect(facade.movie_genres).to be_a(Array)
          expect(facade.movie_summary).to be_a(String)
          expect(facade.movie_poster).to be_a(String)
        end
      end
    end
  end
end