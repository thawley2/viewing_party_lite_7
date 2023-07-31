class User < ApplicationRecord
  has_many :user_parties
  has_many :parties, through: :user_parties

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  has_secure_password

  enum role: %w[default admin] 

  def hosted_parties
    parties.where("user_parties.is_host = true")
  end

  def invited_parties
    parties.where("user_parties.is_host = false")
  end

  def self.other_users(id)
    where.not(id: id)
  end
end
