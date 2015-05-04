module SessionConcern
  extend ActiveSupport::Concern

  def current_user
    User.find_by(uuid: session[:uuid]) if session[:uuid]
  end
end