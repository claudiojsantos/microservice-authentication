FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email { "john.doe@c2s.com" }
    password { "12345678" }
    password_confirmation { "12345678" }
  end
end
