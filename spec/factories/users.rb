FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email(name: name, separators: ['-']) }
    password {Faker::Internet.password}
    password_confirmation {password}
  end
end