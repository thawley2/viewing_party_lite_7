require 'rails_helper'

RSpec.describe '/login', type: :feature do
  before(:each) do
    visit login_path
    @user = create(:user)
  end

  describe 'When I visit the login form' do
    it 'I see a form with email and password fields' do
      expect(page).to have_content('Login')
      expect(page).to have_content('Email:')
      expect(page).to have_content('Password:')
      expect(page).to have_field(:email)
      expect(page).to have_field(:password)
      expect(page).to have_button('Log In')
    end

    it 'When I fill out the form with the correct information and click log in I see my user dashboard' do
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password

      click_button('Log In')

      expect(current_path).to eq(user_path(@user.id))
      expect(page).to have_content("#{@user.name}'s Dashboard")
    end

    it 'When I fill out the form with incorrect password and click log in I see an error message and the login form' do
      fill_in :email, with: @user.email
      fill_in :password, with: 'password'

      click_button('Log In')

      expect(page).to have_content('Email or Password does not exist')
    end

    it 'When I fill out the form with incorrect email and click log in I see an error message and the login form' do
      fill_in :email, with: 'email@email.com'
      fill_in :password, with: @user.password

      click_button('Log In')

      expect(page).to have_content('Email or Password does not exist')
    end
  end
end