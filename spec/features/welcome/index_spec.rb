require 'rails_helper'

RSpec.describe '/', type: :feature do
  describe 'When a user visits the root path' do
    before(:each) do
      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)
      visit root_path
    end
    it "should be on the landing page ('/') and I see the title of the applications" do
      expect(page).to have_content('Viewing Party')
    end

    it 'I see a button to create a new user' do
      expect(page).to have_button('Create a New User')
    end
    
    it 'I see a link (Home) that will take me back to the welcome page' do
      expect(page).to have_link('Home')
      
      click_link('Home')
      
      expect(current_path).to eq(root_path)
    end

    it 'I see a button to log in' do
      expect(page).to have_button('Log In')
    end

    it 'When I click the log in button I am taken to a login form' do
      click_button('Log In')

      expect(current_path).to eq(login_path)
    end

    it 'When a user is not logged in they do not see existing users' do
      expect(page).to_not have_content('Existing Users')
    end
  end

  describe 'When a user is logged in' do
    before(:each) do
      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)
    end
    it 'I dont see the create new user or Log in button' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
      visit root_path
      expect(page).to_not have_button('Create a New User')
      expect(page).to_not have_button('Log In')
    end
    
    it 'I see a button to Log out' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
      visit root_path
      expect(page).to have_button('Log Out')
    end

    it 'When I click the log out button I am taken back to the landing page and see the login/createuser buttons' do
      visit root_path
      click_button('Log In')
      fill_in :email, with: @user1.email
      fill_in :password, with: @user1.password

      click_button('Log In')
      click_link('Home')
      click_button('Log Out')
      expect(current_path).to eq(root_path)
      expect(page).to have_button('Log In')
      expect(page).to have_button('Create a New User')
      expect(page).to_not have_button('Log Out')
    end

    it 'When a user is logged in they see a list of existing users emails' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
      visit root_path
      expect(page).to have_content('Existing Users')
      
      within "#user_#{@user1.id}" do
        expect(page).to have_content(@user1.email)
      end
      within "#user_#{@user2.id}" do
        expect(page).to have_content(@user2.email)
      end
      within "#user_#{@user3.id}" do
        expect(page).to have_content(@user3.email)
      end
    end
  end
end