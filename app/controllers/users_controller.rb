class UsersController < ApplicationController

  def index
    p "CURRENT USER:"
    p current_user
    p "SESSION UUID:"
    p session[:uuid]
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
