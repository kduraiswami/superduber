class UsersController < ApplicationController

  def index
    render json: User.all
  end

  def create
  end

  def show
  end

  def edit
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :uber_token, :phone)
  end

end
