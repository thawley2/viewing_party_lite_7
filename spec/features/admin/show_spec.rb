require 'rails_helper'

RSpec.describe '/admin/users/:id', type: :feature do
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @user3 = create(:user)

    @party1 = create(:party, movie_id: 550, start_time: "04:30:45 UTC")
    @party2 = create(:party, movie_id: 551, start_time: "04:35:30 UTC")

    @user_party1 = UserParty.create!(user: @user1, party: @party2)
    @user_party2 = UserParty.create!(user: @user3, party: @party1)
    @user_party3 = UserParty.create!(user: @user2, party: @party1)
    @user_party4 = UserParty.create!(user: @user1, party: @party1, is_host: true)
    @user_party5 = UserParty.create!(user: @user2, party: @party2, is_host: true)
  end

  describe 'When I visit the users dashboard page' do
    it 'I see <users name> Dashboard" at the top of the page' do
      VCR.use_cassette('all_movie_data_by_id_550_551', :allow_playback_repeats => true) do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
        visit dashboard_path
        expect(page).to have_content("#{@user1.name}'s Dashboard")
      end
    end

    it 'I see a button to go to my dashboard' do
      VCR.use_cassette('all_movie_data_by_id_550_551', :allow_playback_repeats => true) do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
        visit dashboard_path
        expect(page).to have_link('Dashboard')
        
        click_link('Dashboard')
        
        expect(current_path).to eq(dashboard_path)
      end
    end

    it 'has a button (Discover Movies)' do
      VCR.use_cassette('all_movie_data_by_id_550_551', :allow_playback_repeats => true) do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
        visit dashboard_path
        expect(page).to have_button('Discover Movies')
      end
    end

    it 'has a section that list viewing parties' do
      VCR.use_cassette('all_movie_data_by_id_550_551', :allow_playback_repeats => true) do
        title_550 = MovieFacade.get_movie_title(550)
        title_551 = MovieFacade.get_movie_title(551)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)

        visit dashboard_path

        expect(page).to have_content('Parties Hosting')
        expect(page).to have_content('Parties Attending')

        within "#hosting" do
          expect(page).to have_content(title_550)
          expect(page).to have_css('img')
          expect(page).to have_content(format_date(@party1.date))
          expect(page).to have_content(format_time(@party1.start_time))
          expect(page).to have_content("Host: #{@user1.name}")
          within "#invitees" do
            expect(page).to have_content('Invited:')
            expect(page).to have_content(@user2.name)
            expect(page).to have_content(@user3.name)
            expect(page).to_not have_content(@user1.name)
          end
        end

        within "#invited" do
          expect(page).to have_content(title_551)
          expect(page).to have_css('img')
          expect(page).to have_content(format_date(@party2.date))
          expect(page).to have_content(format_time(@party2.start_time))
          expect(page).to have_content("Host: #{@user2.name}")
          within "#invitees" do
            expect(page).to have_content('Invited:')
            expect(page).to have_content(@user1.name)
            expect(page).to_not have_content(@user2.name)
          end
        end
      end
    end
  end
end