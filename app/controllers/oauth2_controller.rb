class Oauth2Controller < ApplicationController

  def index
    redirect_to "https://login.uber.com/oauth/authorize?response_type=code&client_id=#{ENV['UBER_CLIENT_ID']}&scope=request%20profile"
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

      render json: user_info.inspect
    end

  end

end

#<HTTParty::Response:0x7fe2aa703570 parsed_response={"picture"=>"https://d1w2poirtb3as9.cloudfront.net/default.jpeg", "first_name"=>"Jonathan", "last_name"=>"Berk", "promo_code"=>"aq776", "email"=>"jdsberk@gmail.com", "uuid"=>"e75ea52d-3c02-4962-8929-a7e21483a9c3"}, @response=#<Net::HTTPOK 200 OK readbody=true>, @headers={"server"=>["nginx"], "date"=>["Sun, 03 May 2015 02:05:09 GMT"], "content-type"=>["application/json"], "content-length"=>["205"], "connection"=>["close"], "x-rate-limit-remaining"=>["999"], "content-language"=>["en"], "etag"=>["\"ba0e4e7bbea97c50024e24aa4ef3b37a80cfb04a\""], "x-rate-limit-reset"=>["1430622000"], "x-rate-limit-limit"=>["1000"], "x-uber-app"=>["uberex-sandbox"], "strict-transport-security"=>["max-age=31536000; includeSubDomains; preload"], "x-xss-protection"=>["1; mode=block"]}>