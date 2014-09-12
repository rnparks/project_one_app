require './application_controller'
class App < ApplicationController


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
      :body =>  { :code => code,
                  :client_id => CLIENT_ID_GOOGLE,
                  :client_secret => CLIENT_SECRET_GOOGLE,
                  :redirect_uri => REDIRECT_URIS_GOOGLE,
                  :grant_type => "authorization_code"
                })
    session[:access_token_google] = response["access_token"]
    redirect to("/market")
  end

  get('/market') do
    password?
    @url_wsj = "http://online.wsj.com/xml/rss/3_7432.xml"
    render(:erb, :"market/market")
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
    password?
    google_quote = HTTParty.get("http://download.finance.yahoo.com/d/quotes.csv?s=GOOG&f=l1.csv")
    @quote = google_quote.split(",")[0].to_f
    render(:erb, :"goog/des")
  end

  get('/goog/is') do
    password?
    render(:erb, :"goog/is")
  end

  get('/goog/bs') do
    password?
    render(:erb, :"goog/bs")
  end

  get('/goog/cf') do
    password?
    render(:erb, :"goog/cf")
  end

  get('/goog/cn') do
    password?
    render(:erb, :"goog/cn")
  end


    ###############################################
    #  Apple Commands #############################

  get('/aapl/des') do
    password?
    aapl_quote = HTTParty.get("http://download.finance.yahoo.com/d/quotes.csv?s=AAPL&f=l1.csv")
    @quote = aapl_quote.split(",")[0].to_f
    render(:erb, :"aapl/des")
  end

  get('/aapl/is') do
    password?
    render(:erb, :"aapl/is")
  end

  get('/aapl/bs') do
    password?
    render(:erb, :"aapl/bs")
  end

  get('/aapl/cf') do
    password?
    render(:erb, :"aapl/cf")
  end

  get('/aapl/cn') do
    password?
    render(:erb, :"aapl/cn")
  end


  ###############################################
  #  Option Pricing Commands #############################

  get('/option') do
    password?
    render(:erb, :"options/option_pricing")
  end

  post('/option') do
    put_call    = params[:select]
    stock_price = params[:stock_price].to_f
    strike_price = params[:strike_price].to_f
    time_to_expire = (params[:time_to_expire].to_f) / 252 #trading days per year
    risk_free_rate = params[:risk_free_rate].to_f
    volatility = params[:volatility].to_f
    @option_price = BlackScholes.optionprice(put_call, stock_price, strike_price, time_to_expire, risk_free_rate, volatility)
    render(:erb, :"options/option_pricing")
  end

end #class end
