module Pricing
  module Index
    #S&P500 Raw Data
    SP500_RAW = HTTParty.get("http://download.finance.yahoo.com/d/quotes.csv?s=%5EGSPC&f=l1.csv")
    SP500_Price = SP500_RAW.split(",")[0].to_f
    SP500_MOVEMENT = SP500_RAW.split(",")[2].gsub("\"", "")

    #Nasdaq Raw Data
    NASDAQ_RAW = HTTParty.get("http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22%5EIXIC%22)&env=store://datatables.org/alltableswithkeys")
    NASDAQ_PRICE = NASDAQ_RAW["query"]["results"]["quote"]["LastTradePriceOnly"]
    NASDAQ_MOVEMENT = NASDAQ_RAW["query"]["results"]["quote"]["Change_PercentChange"]

    #10yr Raw Data
    TEN_YR_RAW = HTTParty.get("http://download.finance.yahoo.com/d/quotes.csv?s=%5ETNX&f=l1.csv")
    TEN_YR_PRICE = TEN_YR_RAW.split(",")[0].to_f
    TEN_YR_MOVEMENT = TEN_YR_RAW.split(",")[2].gsub("\"", "")
  end

  module Currency
    #EURyr Raw Data
    EUR_RAW = HTTParty.get("http://download.finance.yahoo.com/d/quotes.csv?s=EURUSD=X&f=l1.csv")
    #EUR_RAW2 = HTTParty.get("http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22EURUSD%3DX%22)&env=store://datatables.org/alltableswithkeys")
    EUR_PRICE = EUR_RAW.split(",")[0].to_f

    #REAL Pricing
    BRL_RAW = HTTParty.get("http://download.finance.yahoo.com/d/quotes.csv?s=USDBRL=X&f=l1.csv")
    BRL_PRICE = BRL_RAW.split(",")[0].to_f


    JPY_RAW = HTTParty.get("http://download.finance.yahoo.com/d/quotes.csv?s=USDJPY=X&f=l1.csv")
    JPY_PRICE = JPY_RAW.split(",")[0].to_f
  end

  module Commodity
    #Oil
    OIL_RAW = HTTParty.get("http://download.finance.yahoo.com/d/quotes.csv?s=CLV14.NYM&f=l1.csv")
    #EUR_RAW2 = HTTParty.get("http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22EURUSD%3DX%22)&env=store://datatables.org/alltableswithkeys")
    OIL_PRICE = OIL_RAW.split(",")[0].to_f
    OIL_MOVEMENT = OIL_RAW.split(",")[2].gsub("\"", "")

    #GOLD
    GOLD_RAW = HTTParty.get("http://download.finance.yahoo.com/d/quotes.csv?s=GCU14.CMX&f=l1.csv")
    GOLD_PRICE = GOLD_RAW.split(",")[0].to_f
    GOLD_MOVEMENT = GOLD_RAW.split(",")[2].gsub("\"", "")

    #Natural Gas
    NATGAS_RAW = HTTParty.get("http://download.finance.yahoo.com/d/quotes.csv?s=NGV14.NYM&f=l1.csv")
    NATGAS_PRICE = NATGAS_RAW.split(",")[0].to_f
    NATGAS_MOVEMENT = NATGAS_RAW.split(",")[2].gsub("\"", "")
  end
end
