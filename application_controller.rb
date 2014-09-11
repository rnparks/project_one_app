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


class ApplicationController < Sinatra::Base
########################
# Configuration
########################

  configure do
    enable :logging
    enable :method_override
    enable :sessions
    set :session_secret, 'super secret'
    CLIENT_ID_GOOGLE = "447724783620-c6vi7jn7cge9dn1n2p145vvfpjkke4oq.apps.googleusercontent.com"
    EMAIL_ADDRESS_GOOGLE = "447724783620-c6vi7jn7cge9dn1n2p145vvfpjkke4oq@developer.gserviceaccount.com"
    CLIENT_SECRET_GOOGLE = "40OqiWZWRzcA1cPt55eaTA09"
    REDIRECT_URIS_GOOGLE = "http://frozen-escarpment-3408.herokuapp.com/oauth2callback"
    JAVASCRIPT_ORIGINS = "none"
  end

  before do
    logger.info "Request Headers: #{headers}"
    logger.warn "Params: #{params}"
  end

  after do
    logger.info "Response Headers: #{response.headers}"
  end

end #end of ApplicationController Class

