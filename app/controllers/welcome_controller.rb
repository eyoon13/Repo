class WelcomeController < ApplicationController
  # GET /welcome
  def index
     @authUrl = ENV['AUTH_URL']
     if session['access_token'] && session['access_token_secret']
       redirect_to show_path
     end
  end

end
