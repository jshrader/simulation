clear all
set obs 100
gen t = _n

capture clear x1
capture clear x2
capture clear y
capture clear e
gen x1 = 0
replace x1 = 1 if t > 35 & t < 55
gen x2 = 0
replace x2 = 1 if t >=55
gen e = rnormal()
gen y = 2*x1 + 3*x2 + e

reg y x1 x2, r

gen tau = 0
replace tau = 1 if x1 == 1
replace tau = 2 if x2 == 1

reg y tau, r
