###############################################################################
###Adjusted Momentum Strategy
# Load Systematic Investor Toolbox (SIT)
# http://systematicinvestor.wordpress.com/systematic-investor-toolbox/
###############################################################################
setInternet2(TRUE)
con = gzcon(url('http://www.systematicportfolio.com/sit.gz', 'rb'))
source(con)
close(con)
#*****************************************************************
# Load historical data
#****************************************************************** 
load.packages('quantmod')

tickers = spl('SPY,^VIX')

data <- new.env()
getSymbols(tickers, src = 'yahoo', from = '1980-01-01', env = data, auto.assign = T)
for(i in data$symbolnames) data[[i]] = adjustOHLC(data[[i]], use.Adjusted=T)
bt.prep(data, align='remove.na', fill.gaps = T)

VIX = Cl(data$VIX)
bt.prep.remove.symbols(data, 'VIX')

#*****************************************************************
# Setup
#*****************************************************************
prices = data$prices

models = list()

#*****************************************************************
# 200 SMA
#****************************************************************** 
data$weight[] = NA
data$weight[] = iif(prices > SMA(prices, 200), 1, 0)
models$ma200 = bt.run.share(data, clean.signal=T)

#*****************************************************************
# 200 ROC
#****************************************************************** 
roc = prices / mlag(prices) - 1

data$weight[] = NA
data$weight[] = iif(SMA(roc, 200) > 0, 1, 0)
models$roc200 = bt.run.share(data, clean.signal=T)

#*****************************************************************
# 200 VIX MOM
#****************************************************************** 
data$weight[] = NA
data$weight[] = iif(SMA(roc/VIX, 200) > 0, 1, 0)
models$vix.mom = bt.run.share(data, clean.signal=T)

#*****************************************************************
# 200 ER MOM
#****************************************************************** 
forecast = SMA(roc,10)
error = roc - mlag(forecast)
mae = SMA(abs(error), 10)

data$weight[] = NA
data$weight[] = iif(SMA(roc/mae, 200) > 0, 1, 0)
models$er.mom = bt.run.share(data, clean.signal=T)

#*****************************************************************
# Report
#****************************************************************** 
strategy.performance.snapshoot(models, T)
