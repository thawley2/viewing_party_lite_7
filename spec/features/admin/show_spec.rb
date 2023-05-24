require 'rails_helper'

RSpec.describe '/admin/dashboard', type: :feature do
  describe 'When a user with admin status logs in' do
    it 'They are taken to the admin dashboard page' do
      user = create(:user, role: 1)
      visit login_path
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button('Log In')
      expect(current_path).to eq('/admin/dashboard')
    end

    it ''
  end
end