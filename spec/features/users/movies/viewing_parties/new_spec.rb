require 'rails_helper'

RSpec.describe '/users/:id/movies/:id/viewing_party/new', type: :feature do
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @user3 = create(:user)

  end

  describe 'When I visit the new viewing party page' do

    it 'I see the name of the movie title' do
      VCR.use_cassette('find_movies_550', :allow_playback_repeats => true) do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
        @movie = MovieFacade.new(550)
        visit new_movie_viewing_party_path(550)
        expect(page).to have_content("Create a Movie Party for #{@movie.movie_title}")
      end
    end

    it 'I see a button to the discover page' do
      VCR.use_cassette('find_movies_550', :allow_playback_repeats => true) do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
        @movie = MovieFacade.new(550)
        visit new_movie_viewing_party_path(550)

        expect(page).to have_button('Discover Movies')
      end
    end
  end

  describe 'I see a form to create a new Viewing Party' do
    it 'When a user fills out all fields in the form and clicks submit a new viewing party is created' do
      VCR.use_cassette('find_movies_550', :allow_playback_repeats => true) do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
        @movie = MovieFacade.new(550)
        visit new_movie_viewing_party_path(550)

        fill_in :duration, with: 250
        fill_in :date, with: '2023/05/11'
        fill_in :start_time, with: Time.now

        check "#{@user2.name}"

        click_button 'Create Party!'
        expect(current_path).to eq(dashboard_path)
      end
    end
  end

  describe 'If a user does not fill out the entire form' do
    it 'The user does not fill out the date an error message displays' do
      VCR.use_cassette('find_movies_550', :allow_playback_repeats => true) do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
        visit new_movie_viewing_party_path(550)

        fill_in :duration, with: 250
        fill_in :start_time, with: Time.now

        check "#{@user2.name}"

        click_button 'Create Party!'

        expect(current_path).to eq(new_movie_viewing_party_path(550))
        expect(page).to have_content('Please fill out all fields!')
      end
    end

    it 'The user does not fill out the time an error message displays' do
      VCR.use_cassette('find_movies_550', :allow_playback_repeats => true) do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
        visit new_movie_viewing_party_path(550)

        fill_in :duration, with: 250
        fill_in :date, with: '2023/05/11'

        check "#{@user2.name}"

        click_button 'Create Party!'

        expect(current_path).to eq(new_movie_viewing_party_path(550))
        expect(page).to have_content('Please fill out all fields!')
      end
    end
  end
end