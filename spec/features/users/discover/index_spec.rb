require 'rails_helper'

RSpec.describe '/users/:id/discover', type: :feature do
  before(:each) do
    @user1 = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
    visit discover_path
  end

  describe 'When a user visits their users discover page' do
    it 'They see a Discover Top Rated Movies button' do
      expect(page).to have_button('Discover Top Rated Movies')
    end

    it 'The user sees a form to enter a keyword to search by movie title and a search buttong' do
      expect(page).to have_field(:q)
      expect(page).to have_button('Search')
    end
  end

  describe 'When a user clicks on the Discover Top Rated Movies button' do
    it 'They are taken to the movies results page' do
      VCR.use_cassette('top_20_movies', allow_playback_repeats: true) do
        click_button('Discover Top Rated Movies')
        expect(current_path).to eq(movies_path)
      end
    end
  end

  describe 'When a user clicks on the the search button (after a keyword has been input)' do
    it 'They are taken to the movies results page' do
      VCR.use_cassette('search_movies_tremors', allow_playback_repeats: true) do
        fill_in :q, with: 'Tremors'
        
        click_button('Search')
        
        expect(current_path).to eq(movies_path)
      end
    end
  end
end