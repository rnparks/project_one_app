require 'sinatra/base'
require 'httparty'
require 'securerandom'
require 'pry'
require 'json'

class App < Sinatra::Base

  ########################
  # Configuration
  ########################

  configure do
    enable :logging
    enable :method_override
    enable :sessions
    set :session_secret, 'super secret'
    CLIENT_ID = "447724783620-c6vi7jn7cge9dn1n2p145vvfpjkke4oq.apps.googleusercontent.com"
    EMAIL_ADDRESS = "447724783620-c6vi7jn7cge9dn1n2p145vvfpjkke4oq@developer.gserviceaccount.com"
    CLIENT_SECRET = "40OqiWZWRzcA1cPt55eaTA09"
    REDIRECT_URIS = "http://127.0.0.1:9292/oauth2callback"
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
    @google_post = "https://accounts.google.com/o/oauth2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fplus.login&state=#{state}&redirect_uri=#{REDIRECT_URIS}&response_type=code&client_id=#{CLIENT_ID}&access_type=offline"
    render(:erb, :index, :layout => :login)
  end

  get('/oauth2callback') do
    code = params["code"]
    response = HTTParty.post("https://accounts.google.com/o/oauth2/token",
      :body => {:code => code,
                :client_id => CLIENT_ID,
                :client_secret => CLIENT_SECRET,
                :redirect_uri => REDIRECT_URIS,
                :grant_type => "authorization_code"
      })

    session[:access_token] = response["access_token"]
    redirect to("/market")
    end

    get('/market') do
      #S&P500 Raw Data
      sp500_raw = HTTParty.get("http://download.finance.yahoo.com/d/quotes.csv?s=%5EGSPC&f=l1.csv")
      @sp500_price = sp500_raw.split(",")[0].to_f
      @sp500_movement = sp500_raw.split(",")[2].gsub("\"", "")

      #Nasdaq Raw Data
      nasdaq_raw = HTTParty.get("http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22%5EIXIC%22)&env=store://datatables.org/alltableswithkeys")
      @nasdaq_price = nasdaq_raw["query"]["results"]["quote"]["LastTradePriceOnly"]
      @nasdaq_movement = nasdaq_raw["query"]["results"]["quote"]["Change_PercentChange"]




      if session[:access_token] == nil
        redirect to('/')
      else
      render(:erb, :market)
      end
    end

    post('/market') do
      search = params[:search].downcase
      redirect to("/#{search}")
    end


    get('/goog') do
      google_quote = HTTParty.get("http://download.finance.yahoo.com/d/quotes.csv?s=GOOG&f=l1.csv")
      @quote = google_quote.split(",")[0].to_f
      render(:erb, :goog)
    end

    get('/aapl') do
      aapl_quote = HTTParty.get("http://download.finance.yahoo.com/d/quotes.csv?s=AAPL&f=l1.csv")
      @quote = aapl_quote.split(",")[0].to_f
      render(:erb, :aapl)
    end

end #class end

