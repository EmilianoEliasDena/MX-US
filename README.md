Overview

This repository contains a script for analyzing Mexican monthly Gross Domestic Product (GDP) data. The script uses the siebanxicor package to access data from Banco de Mexico's SIE API, the tidyverse and forecast packages for data manipulation and forecasting, and the imputeTS and DisaggregateTS packages for time series imputation and disaggregation.
Requirements

To use this script, you will need the following:

    A Banco de Mexico SIE API key
    R and the following packages: tidyverse, siebanxicor, forecast, imputeTS, DisaggregateTS, and neverhpfilter

Usage

To use this script, follow these steps:

    Clone or download this repository to your local machine
    Open main.R in R or RStudio
    Set your Banco de Mexico SIE API key in the Bapi variable
    Run the script

The script will retrieve and process data for Mexican quarterly GDP and monthly Industrial Production (IP), compute monthly GDP from the processed data using the disaggregate function, perform seasonal adjustment on the monthly GDP data using the seas and seasadj functions, and generate an output gap series using the yth_filter function. The script will then perform stationary tests on the output gap series using the adf.test and pp.test functions, fit a seasonal autoregressive integrated moving average (SARIMA) model to the output gap series using the auto.arima function, and generate a forecast using the fitted model. The script also includes several plotting functions to visualize the data and results.
License

This project is licensed under the MIT License - see the LICENSE file for details.
