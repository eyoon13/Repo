require 'rubygems'
require 'open_weather'
require 'yahoo-finance'
require 'csv'

class SessionsController < ApplicationController
  def create
    credentials = request.env['omniauth.auth']['credentials']
    session[:access_token] = credentials['token']
    session[:access_token_secret] = credentials['secret']
    user = User.where(handle: client.user.screen_name).take
    if user.nil?
      u = User.new(
        name: client.user.name,
        handle: client.user.screen_name,
        zip: "14623",
        tweet_count: 0,
        follower_count: client.user.followers_count,
        auto_tweet: false)
      u.save!
    else
      user.follower_count = client.user.followers_count
      user.tweet_count = client.user.tweets_count
      user.save!
    end
    if user.auto_tweet
      client.update(client.user.name + " logged into Twitter Stocks!")
    end
    redirect_to show_path, notice: 'Signed ins'
  end

  def show
    if session['access_token'] && session['access_token_secret']
      @user = User.where(handle: client.user.screen_name).take
      @tweets = client.home_timeline[0..10]

      lat = 0.0
      long = 0.0
      zipcode = @user.zip.to_s
      CSV.foreach("app/assets/cityzip.csv") do |line|
         if(line[2] == zipcode)
            lat = line[3].to_f
            long = line[4].to_f
            break
         end
      end

      @current = OpenWeather::Current.geocode(lat, long, { units: "imperial", APPID: "106fc5306b995d8409aa88eb9cc548d4" })
      yahoo_client = YahooFinance::Client.new
      ycl = yahoo_client.quotes(['AAPL','MSFT','JPC', 'TWTR', 'LUV' ], [:name, :ask, :bid, :high, :low, :change, :symbol, :last_trade_date])
      @stocks = ycl
    else
      redirect_to failure_path
    end
  end
  
  def writetweet
    if session['access_token'] && session['access_token_secret']
      @tweet = params[:tweet]
      user = User.where(handle: client.user.screen_name).take
      user.tweet_count = client.user.tweets_count
      user.save!
      client.update(@tweet)
      redirect_to show_path
    else
      redirect_to failure_path
    end
  end
  
  def update_settings
    if session['access_token'] && session['access_token_secret']
      user = User.where(handle: client.user.screen_name).take
      user.zip = params[:zipcode]
      if params[:autotweet] == '1'
        user.auto_tweet = true
      else
        user.auto_tweet = false
      end
      user.save!
      redirect_to show_path
    else
      redirect_to failure_path
    end
  end

  def error
    flash[:error] = 'Sign in with Twitter failed'
    redirect_to root_path
  end
  
  def destroy
    if session['access_token'] && session['access_token_secret']
      user = User.where(handle: client.user.screen_name).take
      if user.auto_tweet
        client.update(client.user.name + " logged out of Twitter Stocks")
      end
    end
    reset_session
    redirect_to root_path, notice: 'Signed out'
  end
  
end
