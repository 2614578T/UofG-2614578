***Import dataset
import excel using "XXX.xlsx", firstrow clear


***Cleaning of dataset
drop if date==.

drop if RECI==.

drop if SSE==.

list date in 1/L

list RECI in 1/L

list SSE in 1/L

gen date2 = ym(year(date), month(date))

list  date2 in 1/10

tsset date2


***Statistical description of the dataset
summarize


***Taking the first-order natural logarithm and the difference of the first-order natural logarithm
gen log_RECI = log(RECI)
gen log_SSE = log(SSE)
gen log_M2 = log(M2)
gen log_CPI = log(CPI)
gen log_PU = log(PU)

gen d_log_RECI = D.log_RECI
gen d_log_SSE = D.log_SSE
gen d_log_M2 = D.log_M2
gen d_log_CPI = D.log_CPI
gen d_log_PU= D.log_PU


***ADF test
dfuller log_RECI, lags(0) trend
dfuller log_SSE, lags(0) trend
dfuller log_M2, lags(0) trend
dfuller log_CPI, lags(0) trend
dfuller log_PU, lags(0) trend

dfuller d_log_RECI, lags(0) trend
dfuller d_log_SSE, lags(0) trend
dfuller d_log_M2, lags(0) trend
dfuller d_log_CPI, lags(0) trend
dfuller d_log_PU, lags(0) trend



***Determination of optimal lag period
varsoc d_log_RECI d_log_SSE d_log_M2


***Construction of the VAR model （Using the tranquil period as an example）
var d_log_RECI d_log_SSE d_log_M2, lags(1/1)


***Granger causality test
vargranger


***Check the stability condition of VAR model (unit root circle)
varstable,graph


***Fitting the VAR model with a maximum lag of 10 (for easier observation)
irf create myirf, set(myirfset) step(10) replace


***Impulse Response Function Analysis (Generate Impulse Response Plot)
irf graph oirf, impulse(d_log_RECI) response(d_log_SSE) set(myirfset)
irf graph oirf, impulse(d_log_SSE) response(d_log_RECI) set(myirfset)


***Robustness check
varsoc d_log_RECI d_log_SSE d_log_CPI d_log_PU
var d_log_RECI d_log_SSE d_log_CPI d_log_PU, lags(1/1)
vargranger
