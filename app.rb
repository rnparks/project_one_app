require 'sinatra/base'
require 'httparty'
require 'securerandom'
require 'json'
require './views/pricing'
require './views/google_financials'
require './views/black_scholes'
require 'rss'
require 'open-uri'


class App < Sinatra::Base

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
    REDIRECT_URIS_GOOGLE = "http://127.0.0.1:9292/oauth2callback"
    JAVASCRIPT_ORIGINS = "none"
  end

  before do
    logger.info "Request Headers: #{headers}"
    logger.warn "Params: #{params}"
  end

  after do
    logger.info "Response Headers: #{response.headers}"
  end

  ########################
  # Routes
  ########################

  get('/') do
    state = SecureRandom.urlsafe_base64
    @google_post = "https://accounts.google.com/o/oauth2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fplus.login&state=#{state}&redirect_uri=#{REDIRECT_URIS_GOOGLE}&response_type=code&client_id=#{CLIENT_ID_GOOGLE}&access_type=offline"
    render(:erb, :index, :layout => :login)
  end

  get('/oauth2callback') do
    code = params["code"]
    response = HTTParty.post("https://accounts.google.com/o/oauth2/token",
      :body => {:code => code,
                :client_id => CLIENT_ID_GOOGLE,
                :client_secret => CLIENT_SECRET_GOOGLE,
                :redirect_uri => REDIRECT_URIS_GOOGLE,
                :grant_type => "authorization_code"
      })

    session[:access_token_google] = response["access_token"]
    redirect to("/market")
    end

    get('/market') do
      if session[:access_token_google] == nil
        redirect to('/')
      else
      @url_wsj = "http://online.wsj.com/xml/rss/3_7432.xml"
      render(:erb, :market)
      end
    end

    post('/market') do
      search = params[:search].downcase.split(" ")
      if search.size == 1
        redirect to("/#{search[0]}")
      else
        redirect to("/#{search[0]}/#{search[1]}")
      end
    end


    ###############################################
    #  Google Commands #############################

    get('/goog/des') do
      google_quote = HTTParty.get("http://download.finance.yahoo.com/d/quotes.csv?s=GOOG&f=l1.csv")
      @quote = google_quote.split(",")[0].to_f
      render(:erb, :goog)
    end

    get('/goog/is') do
      render(:erb, :goog_is)
    end

    get('/goog/bs') do
      render(:erb, :goog_bs)
    end

    get('/goog/cf') do
      render(:erb, :goog_cf)
    end

    get('/goog/cn') do
      render(:erb, :goog_cn)
    end


    ###############################################
    #  Apple Commands #############################

    get('/aapl/des') do
      aapl_quote = HTTParty.get("http://download.finance.yahoo.com/d/quotes.csv?s=AAPL&f=l1.csv")
      @quote = aapl_quote.split(",")[0].to_f
      render(:erb, :aapl)
    end

    get('/aapl/is') do
      render(:erb, :aapl_is)
    end

    get('/aapl/bs') do
      render(:erb, :aapl_bs)
    end

    get('/aapl/cf') do
      render(:erb, :aapl_cf)
    end

    get('/aapl/cn') do
      render(:erb, :aapl_cn)
    end


    ###############################################
    #  Option Pricing Commands #############################

    get('/option') do
      render(:erb, :option_pricing)
    end

    post('/option') do
      put_call    = params[:select]
      stock_price = params[:stock_price].to_f
      strike_price = params[:strike_price].to_f
      time_to_expire = (params[:time_to_expire].to_f) / 252 #trading days per year
      risk_free_rate = params[:risk_free_rate].to_f
      volatility = params[:volatility].to_f
      @option_price = BlackScholes.optionprice(put_call, stock_price, strike_price, time_to_expire, risk_free_rate, volatility)
      render(:erb, :option_pricing)
    end

end #class end


