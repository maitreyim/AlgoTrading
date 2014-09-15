####INTRADAY DATA#####
##############################################################################
# Load Systematic Investor Toolbox (SIT)
# http://systematicinvestor.wordpress.com/systematic-investor-toolbox/
###############################################################################
setInternet2(TRUE)
con = gzcon(url('http://www.systematicportfolio.com/sit.gz', 'rb'))
source(con)
close(con)

#*****************************************************************
# Load Intraday data
#****************************************************************** 
data = getSymbol.intraday.google('GOOG', 'NASDAQ', 60, '5d')
last(data, 10)
plota(data, type='candle', main='Google Intraday prices')
