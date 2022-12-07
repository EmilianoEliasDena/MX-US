###
###     Mexican Monthly GDP
###

###     Clean environment 
rm(list = ls())

###     Library
library(pacman)
p_load(tidyverse,
       siebanxicor,
       forecast,
       imputeTS,
       DisaggregateTS,
       neverhpfilter)

###     BANXICO SIE api
Bapi <- "507f81fa14673a622ce98915c134dbfa1c1767a4497216c77a51b342db3019cf"
siebanxicor::setToken(Bapi)

###     INFORMATION
id_GDP <- "SR16573"
id_IP <- "SR16734"
e_q = c(2022, 3)
e_m = c(2022, 9)

###     GET_DATA
GET_DATA <- function(id, end, freq){
  
  y <- getSeriesData(id)[[1]][2] %>% 
    unlist() %>% 
    as.numeric() %>% 
    ts(end = end, frequency = freq) %>% 
    imputeTS::na_kalman()
  
  return(y)
  
}

###     DATA
GDP_MXq <- GET_DATA(id = id_GDP, end = e_q, freq = 4) %>% log()
IP_MXm <- GET_DATA(id = id_IP, end = e_m, freq = 12) %>% log()

###     PLOTS GDP/IP
autoplot(GDP_MXq)
autoplot(IP_MXm)

###     Monthly GDP
#       Vectors
Y <- matrix(data = as.vector(GDP_MXq), ncol = 1)
X <- matrix(data = as.vector(IP_MXm), ncol = 1)

#       Monthly GDP 
GDP_MXm <- DisaggregateTS::disaggregate(Y = Y, 
                                        X = X, 
                                        aggMat = "average", 
                                        aggRatio = 3, 
                                        method = "spTD")[1] %>% 
           unlist() %>% as.numeric() %>% 
           ts(end = e_m, frequency = 12)
autoplot(GDP_MXm)

#      Monthly GDP seasonal adjusted
GDP_MXm_sa <- GDP_MXm %>% 
              seasonal::seas() %>% 
              forecast::seasadj()

#      Plot
autoplot(cbind(GDP_MXm, GDP_MXm_sa)) + xlab("Time")+ylab("Monthly GDP (s.a.)")

###       Monthly Output Gap
OGAP_MXm <- yth_filter(x = as.xts(GDP_MXm_sa), 
                       h = 24, p = 12, output = c("cycle"))

autoplot(OGAP_MXm*100)

tseries::adf.test(OGAP_MXm)
tseries::pp.test(OGAP_MXm)

model <- forecast::auto.arima(y = OGAP_MXm, 
                     ic = "bic", 
                     trace = TRUE, 
                     approximation = FALSE)  
checkresiduals(model)
forecast <- forecast(model)  
autoplot(forecast)
