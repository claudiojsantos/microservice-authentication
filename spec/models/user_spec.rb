require "rails_helper"

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }

  it { should have_secure_password }

  describe "password encryption" do
    let(:user) { User.create(email: "teste@teste.com.br", password: "12345678", password_confirmation: "12345678") }

    it "valid password" do
      expect(user.authenticate("12345678")).to be_truthy
    end

    it "invalid password" do
      expect(user.authenticate("123456")).to be_falsey
    end
  end
end
