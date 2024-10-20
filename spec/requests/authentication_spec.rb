require 'rails_helper'

RSpec.describe "Auth::Authentications", type: :request do
  describe "POST #login" do
    let(:user) { create(:user) }
    let(:url) { '/auth/login' }

    context 'when credentials are valid' do
      it 'returns a token' do
        post url, params: { email: user.email, password: user.password }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end
  end

  describe "POST #signup" do
    let(:url) { '/auth/signup' }
    let(:user) { build(:user) }

    context 'when signup is successful' do
      it 'create a new user and returns a JWT token' do
        post url, params: { name: user.name, email: user.email, password: user.password, password_confirmation: user.password }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context 'when signup fails' do
      it 'returns errors' do
        post url, params: { name: user.name, email: user.email, password: user.password, password_confirmation: 'invalid' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('error')
        expect(JSON.parse(response.body)['error']).to include("Password confirmation doesn't match Password")
      end
    end
  end

  describe "GET #token_validate" do
    let(:url) { '/auth/token_validate' }
    let(:user) { create(:user) }

    context 'when token is valid' do
      it 'returns the user' do
        token = JwtService.encode({ user_id: user.id, email: user.email })
        headers = { "Authorization" => "Bearer #{token}" }

        get url, headers: headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('user')
      end
    end

    context 'when token is invalid' do
      it 'returns an error' do
        headers = { "Authorization" => "Bearer invalid_token" }

        get url, headers: headers

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end
end
