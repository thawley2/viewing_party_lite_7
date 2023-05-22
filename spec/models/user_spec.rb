require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @user3 = create(:user)

    @party1 = create(:party, movie_id: 2)
    @party2 = create(:party, movie_id: 3)

    @user_party1 = UserParty.create!(user: @user1, party: @party2)
    @user_party2 = UserParty.create!(user: @user3, party: @party1)
    @user_party3 = UserParty.create!(user: @user2, party: @party1)
    @user_party4 = UserParty.create!(user: @user1, party: @party1, is_host: true)
    @user_party5 = UserParty.create!(user: @user2, party: @party2, is_host: true)
  end

  describe 'relationships' do
    it {should have_many(:user_parties)}
    it {should have_many(:parties).through(:user_parties)}
  end

  describe 'validations' do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:email)}
    it {should validate_uniqueness_of(:email).case_insensitive}
    it {should validate_confirmation_of(:password)}
    it {should validate_presence_of(:password_confirmation)}
  end

  describe 'instance methods' do
    describe '#hosted_parties' do
      it 'returns an array of all parties the user is hosting' do
        expect(@user1.hosted_parties).to eq([@party1])
      end
    end

    describe '#invited_parties' do
      it 'returns an array of all parties the user is invited to but not hosting' do
        expect(@user1.invited_parties).to eq([@party2])
        expect(@user1.invited_parties).to_not include(@party1)
      end
    end
  end

  describe 'class methods' do
    describe '#other_users' do
      it 'returns an array of all users except the specified user' do
        expect(User.other_users(@user1.id)).to match_array([@user2, @user3])
      end
    end
  end
end