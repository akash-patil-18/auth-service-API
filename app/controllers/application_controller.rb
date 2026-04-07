class ApplicationController < ActionController::API
  include Pundit
  
  before_action :authenticate_request

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  attr_reader :current_user

  private

  def authenticate_request
    header = request.headers['Authorization']

    # Expecting: "Bearer <token>"
    token = header.split(' ').last if header

    decoded = JsonWebToken.decode(token)

    if decoded
      @current_user = User.find_by(id: decoded[:user_id])
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def user_not_authorized
    render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
  end
end
