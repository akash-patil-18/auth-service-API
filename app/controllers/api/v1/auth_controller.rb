class Api::V1::AuthController < ApplicationController
  # Skip authentication for signup & login
  skip_before_action :authenticate_request, only: [:signup, :login]

  # Signup API
  def signup
    user = User.new(user_params)

    if user.save
      # Generate token after successful signup
      token = JsonWebToken.encode(user_id: user.id)

      render json: {
        message: 'User created successfully',
        token: token
      }, status: :created
    else
      render json: {
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # Login API
  def login
    user = User.find_by(email: params[:email])

    # authenticate method comes from has_secure_password
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)

      render json: {
        message: 'Login successful',
        token: token
      }
    else
      render json: {
        error: 'Invalid email or password'
      }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:email, :password, :role)
  end
end
