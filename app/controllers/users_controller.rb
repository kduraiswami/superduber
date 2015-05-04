class UsersController < ApplicationController

  def index
    p "CURRENT USER:"
    p current_user
    p "SESSION UUID:"
    p session[:uuid]
    byebug
    render json: User.all
  end

  def show
  end

  def edit
  end

end
