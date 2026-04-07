class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [:signup, :login, :refresh]

  # Signup
  def signup
    user = User.new(user_params)

    if user.save
      render_token_response(user)
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Login
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      render_token_response(user)
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # Refresh Token API
  def refresh
    user = User.find_by(refresh_token: params[:refresh_token])

    if user
      # Generate new access token
      access_token = JsonWebToken.encode(user_id: user.id)

      render json: {
        access_token: access_token
      }
    else
      render json: { error: 'Invalid refresh token' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:email, :password, :role)
  end

  # Common method for token generation
  def render_token_response(user)
    access_token = JsonWebToken.encode(user_id: user.id)

    # Generate refresh token
    refresh_token = SecureRandom.hex(32)

    # Save refresh token in DB
    user.update(refresh_token: refresh_token)

    render json: {
      access_token: access_token,
      refresh_token: refresh_token
    }
  end
end
