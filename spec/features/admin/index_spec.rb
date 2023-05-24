require 'rails_helper'

RSpec.describe '/admin/dashboard', type: :feature do
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @user3 = create(:user)
    @user4 = create(:user, role: 1)
    @user5 = create(:user, role: 1)
  end
  describe 'When a user with admin status logs in' do
    it 'They are taken to the admin dashboard page' do
      user = create(:user, role: 1)
      visit login_path
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button('Log In')

      expect(current_path).to eq('/admin/dashboard')
    end

    it 'They see a list of all the non admin users listed' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user5)

      visit admin_dashboard_path

      within "#user_#{@user1.id}" do
        expect(page).to have_link(@user1.email)
      end
      within "#user_#{@user2.id}" do
        expect(page).to have_link(@user2.email)
      end
      within "#user_#{@user3.id}" do
        expect(page).to have_link(@user3.email)
      end

      expect(page).to_not have_content(@user4.email)
    end

    it 'When I click on a users email link, I am taken their dashboard page' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user5)

      visit admin_dashboard_path

      click_link @user1.email

      expect(current_path).to eq(admin_path(@user1.id))
    end
  end
end