class Api::V1::UsersController < ApplicationController
  def index
    users = User.all

    # Authorization check
    authorize users

    render json: users
  end

  def show
    user = User.find(params[:id])

    authorize user

    render json: user
  end

  def destroy
    user = User.find(params[:id])

    authorize user

    user.destroy

    render json: { message: 'User deleted successfully' }
  end

  def profile
    render json: {
      message: "User profile fetched successfully",
      user: {
        id: current_user.id,
        email: current_user.email,
        role: current_user.role
      }
    }
  end
end
