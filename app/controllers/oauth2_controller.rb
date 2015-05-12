class Oauth2Controller < ApplicationController

  def index
    redirect_to "https://login.uber.com/oauth/authorize?response_type=code&client_id=#{ENV['UBER_CLIENT_ID']}"
  end

  def callback
    if params[:error]
      render json: {message: params[:error]}, status: :unauthorized
    elsif params[:code]
      response = HTTParty.post("https://login.uber.com/oauth/token",
        query: {
          client_secret: ENV['UBER_SECRET'],
          client_id: ENV['UBER_CLIENT_ID'],
          grant_type: 'authorization_code',
          redirect_uri: 'http://localhost:3000/oauth2/callback',
          code: params[:code] })
      access_token = response["access_token"]
      refresh_token = response["refresh_token"]
      p "Access token: #{access_token}"

      user_info = HTTParty.get("https://sandbox-api.uber.com/v1/me",
        headers: {"Authorization" => "Bearer #{access_token}", "scope" => "profile" }
        )

      params[:user] = user_info #what is this for?
      user = User.find_or_create_by(uuid: user_info["uuid"])
      user.update!(user_params)
      user.uber_access_token = access_token
      user.uber_refresh_token = refresh_token
      user.save!
      session[:uuid] = user_info["uuid"]

      # render json: user.inspect
      redirect_to '/'
    end

  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :uber_token, :phone, :uuid, :picture)
  end

end