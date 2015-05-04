class UsersController < ApplicationController

  def index
    render json: User.all
  end

  def show
  end

  def edit
  end

  def reset_session
    session.clear
    p "CLEARED SESSION!"
    redirect_to root_path
  end

end
