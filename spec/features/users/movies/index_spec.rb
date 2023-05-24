require 'rails_helper'

RSpec.describe '/users/:id/movies#index' do
  before(:each) do
    @user1 = create(:user)
  end

  describe 'When a user visits the discovery page' do
    describe 'And they click on Discover Top Rated Movies' do
      it 'They are taken to the user movies index page where a list of the top movies is rendered' do
        VCR.use_cassette('top_20_movies', allow_playback_repeats: true) do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
          top_movies = MoviesFacade.new.movies

          visit discover_path
          click_button ('Discover Top Rated Movies')

          expect(current_path).to eq(movies_path)

          expect(page).to have_content('Viewing Party')
          expect(page).to have_button('Discover Page')
          expect(page).to have_link('Dashboard')

          top_movies.each do |movie|
            within "#movie_#{movie.id}" do
              expect(page).to have_content(movie.title)
              expect(page).to have_content("Vote Average: #{movie.vote_average}")
            end
          end
        end
      end

      it 'Each movie name listed is a link to their show page' do
        VCR.use_cassette('this_should_work', allow_playback_repeats: true) do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
          top_movies = MoviesFacade.new.movies
          first_movie = top_movies.first

          visit discover_path
          click_button ('Discover Top Rated Movies')

          within "#movie_#{first_movie.id}" do
            click_link(first_movie.title)
            expect(current_path).to eq(movie_path(first_movie.id))
          end
        end
      end

      it 'When search field is not filled in or spaces added and the Search button is clicked, top movies are returned' do
        VCR.use_cassette('top_20_movies', allow_playback_repeats: true) do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
          top_movies = MoviesFacade.new.movies
          visit discover_path

          fill_in :q, with: ' '
          click_button 'Search'

          top_movies.each do |movie|
            within "#movie_#{movie.id}" do
              expect(page).to have_content(movie.title)
              expect(page).to have_content("Vote Average: #{movie.vote_average}")
            end
          end
          visit discover_path

          click_button 'Search'

          top_movies.each do |movie|
            within "#movie_#{movie.id}" do
              expect(page).to have_content(movie.title)
              expect(page).to have_content("Vote Average: #{movie.vote_average}")
            end
          end
        end
      end
    end

    describe 'When they fill in the search field and click search' do
      it 'They are taken to the movie index page where the 20 results for their search are listed' do
        VCR.use_cassette('search_movies_tremors', allow_playback_repeats: true) do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
          search_movies = MoviesFacade.new('Tremors').movies
          visit discover_path

          fill_in :q, with: 'Tremors'
          click_button ('Search')

          expect(current_path).to eq(movies_path)

          expect(page).to have_content('Viewing Party')
          expect(page).to have_button('Discover Page')

          search_movies.each do |movie|
            within "#movie_#{movie.id}" do
              expect(page).to have_content(movie.title)
              expect(page).to have_content("Vote Average: #{movie.vote_average}")
            end
          end
        end
      end

      it 'Each movie name listed in the search results is a link to their show page' do
        VCR.use_cassette('does_this_work', allow_playback_repeats: true) do
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
          search_movies = MoviesFacade.new('Tremors').movies
          first_movie = search_movies.first

          search_movies = MoviesFacade.new('Tremors').movies
          visit discover_path

          fill_in :q, with: 'Tremors'
          click_button ('Search')

          within "#movie_#{first_movie.id}" do
            click_link(first_movie.title)
            expect(current_path).to eq(movie_path(first_movie.id))
          end
        end
      end
    end
  end
end
