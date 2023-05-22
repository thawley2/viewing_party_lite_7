require 'rails_helper'

RSpec.describe '/register', type: :feature do
  before(:each) do
    visit new_user_path
  end

  describe 'When a user visits the "/register" path' do
    it 'I should see a form to register' do
      expect(page).to have_content('Register a New User')
    end

    it 'form should include a name' do
      expect(page).to have_field('Name:')
    end

    it 'form should include an e-mail' do
      expect(page).to have_field('E-mail Address:')
    end

    it 'form should include a password' do
      expect(page).to have_field('Password:')
    end

    it 'form should include a confirm password' do
      expect(page).to have_field('Confirm Password:')
    end

    it 'form should include a register button' do
      expect(page).to have_button('Register')
    end

    it 'should take user to their user dashboard on successful registration' do
      fill_in 'Name', with: 'Jane Doe'
      fill_in 'E-mail Address:', with: 'jane-doe@gmail.com'
      fill_in 'Password:', with: '12345'
      fill_in 'Confirm Password:', with: '12345'
      click_button 'Register'

      expected_user = User.last
      expect(current_path).to eq(user_path(expected_user))
    end

    it 'should not allow users to register without a unique e-mail address' do
      user = create(:user)

      fill_in 'Name', with: "#{user.name}"
      fill_in 'E-mail Address:', with: "#{user.email}"
      click_button 'Register'

      expect(page).to have_content("A name and unique email must be present.")
    end

    it 'should not allow users to register without a name' do
      user = create(:user)

      fill_in 'E-mail Address:', with: "#{user.email}"
      click_button 'Register'

      expect(page).to have_content("A name and unique email must be present.")
    end

    it 'should not allow users to register without an e-mail address' do
      user = create(:user)

      fill_in 'Name', with: "#{user.name}"
      click_button 'Register'

      expect(page).to have_content("A name and unique email must be present.")
    end
  end
end
