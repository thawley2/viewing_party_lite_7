require 'rails_helper'

RSpec.describe '/users/movies/:id' do
  before(:each) do
    VCR.use_cassette('test_for_links_top_movies', :allow_playback_repeats => true) do
      @user1 = create(:user)

      visit discover_path

      click_button 'Discover Top Rated Movies'

      movies = MoviesFacade.new.movies
      @movie = movies.first

      within("#movie_#{@movie.id}") do
        VCR.use_cassette('test_individual_movie', :allow_playback_repeats => true) do
          click_link(@movie.title)

          @selected_movie = MovieFacade.new(@movie.id).movie
          @reviews = MovieFacade.new(@movie.id).reviews
          @cast = MovieFacade.new(@movie.id).cast
        end
      end
    end
  end

  describe 'When I visit a movies details page' do
    it 'should have a button that links to a page to create a new viewing party' do
      VCR.use_cassette('movie_273_show_page', :allow_playback_repeats => true) do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
        visit movie_path(273)
        
        expect(page).to have_button('Create Viewing Party')
        expect(page).to have_link('Dashboard')
        click_button 'Create Viewing Party'
        
        expect(current_path).to eq(new_movie_viewing_party_path(273))
      end
    end

    it 'should have a button that links to the discover page' do
      VCR.use_cassette('movie_details', :allow_playback_repeats => true) do
        expect(page).to have_button('Discover Page')
        
        click_button 'Discover Page'
        
        expect(current_path).to eq(discover_path)
      end
    end

    it 'should have information about the specific movie' do
      VCR.use_cassette('movie_details', :allow_playback_repeats => true) do
        expect(page).to have_content(@selected_movie.title)
        expect(page).to have_content("Vote Average: #{@selected_movie.vote_average}")
        expect(page).to have_content("Runtime: 2h 55m")
        
        @selected_movie.genres.each do |genre|
          expect(page).to have_content(genre)
        end
        
        expect(page).to have_content(@selected_movie.summary)
        
        expect(page).to have_css('.cast', maximum: 10)
        
        @cast.each do |cast_member|
          expect(page).to have_content(cast_member.character)
          expect(page).to have_content(cast_member.name)
        end
        
        expect(page).to have_content("#{@reviews.count} Reviews")
        
        @reviews.each do |review|
          expect(page).to have_content(review.author)
          # expect(page).to have_content(review.content)
        end
      end
    end

    it 'returns an error message if a visitor is not logged in and clicks create viewing party' do
      VCR.use_cassette('movie_no_log_in', :allow_playback_repeats => true) do

        expect(page).to have_button('Create Viewing Party')
        
        click_button 'Create Viewing Party'
        
        expect(current_path).to eq(movie_path(@movie.id))
        expect(page).to have_content('Must be logged in to create a Viewing Party.')
      end
    end
  end
end
