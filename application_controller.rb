require 'sinatra/base'
require 'httparty'
require 'securerandom'
require 'json'
require 'rss'
require 'open-uri'

###### REQUIRE HELPERS #####

require './helpers/financial_parse'
require './helpers/black_scholes'
require './helpers/pricing'
require './helpers/ryan_functions'


class ApplicationController < Sinatra::Base
########################
# Configuration
########################

  configure do
    enable :logging
    enable :method_override
    enable :sessions
    set :session_secret, 'super secret'
    JAVASCRIPT_ORIGINS    = "none"
    CLIENT_ID_GOOGLE      = ENV["CLIENT_ID_GOOGLE"]
    EMAIL_ADDRESS_GOOGLE  = ENV["EMAIL_ADDRESS_GOOGLE"]
    CLIENT_SECRET_GOOGLE  = ENV["CLIENT_SECRET_GOOGLE"]
  end

  configure :development do
    REDIRECT_URIS_GOOGLE = "http://127.0.0.1:9292/oauth2callback"
  end

  configure :production do
    REDIRECT_URIS_GOOGLE = "http://frozen-escarpment-3408.herokuapp.com/oauth2callback"
  end

  before do
    logger.info "Request Headers: #{headers}"
    logger.warn "Params: #{params}"
  end

  after do
    logger.info "Response Headers: #{response.headers}"
  end

  def password?
    redirect to('/') if session[:access_token_google] == nil
  end

end #end of ApplicationController Class

