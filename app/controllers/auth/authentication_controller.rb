module Auth
  class AuthenticationController < ApplicationController
    def login
      @user = User.find_by(email: params[:email])

      if @user&.authenticate(params[:password])
        token = JwtService.encode({ user_id: @user.id, email: @user.email })
        render json: { token: token }, status: :ok
      else
        render json: { error: "Invalid email or password" }, status: :unauthorized
      end
    end

    def signup
      @user = User.new(user_params)

      if @user.save
        token = JwtService.encode({ user_id: @user.id, email: @user.email })
        render json: { token: token }, status: :created
      else
        render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def token_validate
      token = request.headers["Authorization"]&.split(" ")&.last
      decoded_token = JwtService.decode(token)

      if decoded_token
        user = User.find(decoded_token[:user_id])
        if user
          render json: { user: user }, status: :ok
        else
          render json: { error: "Invalid token" }, status: :unauthorized
        end
      else
        render json: { error: "Invalid token" }, status: :unauthorized
      end
    end

    private

    def user_params
      params.permit(:name, :email, :password, :password_confirmation)
    end
  end
end
