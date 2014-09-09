module BlackScholes
  include Math

# Cumulative normal distribution
  def self.cnd(x)
    a1, a2, a3, a4, a5 = 0.31938153, -0.356563782, 1.781477937, -1.821255978, 1.330274429
    l = x.abs
    k = 1.0 / (1.0 + 0.2316419 * l)
    w = 1.0 - 1.0 / Math.sqrt(2*Math::PI)*Math.exp(-l*l/2.0) * (a1*k + a2*k*k + a3*(k**3) + a4*(k**4) + a5*(k**5))
    w = 1.0 - w if x < 0
    return w
  end

  #all values must be entered as floats
  # s = stock_price
  # x = strike_price
  # t = time in fraction of a year
  # v = volatility measured in standard deviation

  def self.optionprice(callPutFlag, s, x, t, r, v)
    d1 = (Math.log(s/x)+(r+v*v/2.0)*t)/(v*Math.sqrt(t))
    d2 = d1-v*Math.sqrt(t)
    if callPutFlag == 'c'
      s*cnd(d1)-x*Math.exp(-r*t)*cnd(d2)
    else
      x*Math.exp(-r*t)*cnd(-d2)-s*cnd(-d1)
    end
  end

end #module end
