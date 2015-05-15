module HomeHelper
  def current_user
    if session[:uuid]
      User.find_by(uuid: session[:uuid]) 
    end
  end
end
