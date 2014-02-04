// Simulating vote share estimation
//
// First version: 2012-08-15
// This version: 2012-08-15
//

// Preliminaries
clear all

// Creating mock data
// Set data size 
set obs 90
// First try, 3 states with variability coming from the number of
// parties, 10 years
gen state = 1
replace state = 2 in 21/50
replace state = 3 in 51/90

// Constant party numbers over time
gen num_parties_const = 2
replace num_parties_const = 3 if state == 2
replace num_parties_const = 4 if state == 3

// Party ID
gen party_id = 10
forvalues k = 10 20 to 80 {
  local start_val = `k' + 1
  local end_val = `k' + 10
  replace party_id = `end_val' in `start_val'/`end_val'
}

// Years
// We specified party ID in the odd way we did so that we could
// easily create year values
gen year = _n
replace year = year - party_id + 10

// Some covariates
// Individual specific
gen x_indiv = runiform()
// Year specific
gen temp = runiform()
bysort year: egen x_time = mean(temp)
drop temp
// State specific
gen temp = runiform()
bysort state: egen x_state = mean(temp)
drop temp
// Error
gen eps = rnormal(0,.1)
quietly: su eps
replace eps = eps - r(min)


// Vote share
// The model I have in mind is
// vote_share = f(b1*incumbent + b2*x_indiv + b3*x_time + b4*x_state + eps)
// Initialization of incumbency
gen incumbent = .
gen rand = runiform()
bysort state year: egen max_rand = max(rand)
replace incumbent = 1 if max_rand == rand & year == 1
replace incumbent = 0 if incumbent != 1 & year == 1
drop rand max_rand

// Now recursively define the outcome variable and future incumbency
gen vote_share = 1*incumbent + 2*x_indiv + .3*x_time + .2*x_state + eps if year == 1
// Incumbency in future years is determined by last year's election
forvalues k = 2/10 {
  bysort state year: egen max_vote = max(vote_share)
  bysort state party_id (year): replace incumbent = 1 if max_vote[_n-1] == vote_share[_n-1] & year == `k'
  replace incumbent = 0 if incumbent != 1 & year == `k'
  //replace vote_share = 1*incumbent + .5*x_indiv + .3*x_time + .2*x_state + eps if year == `k'
  replace vote_share = 1*incumbent + 2*x_indiv + eps if year == `k'
  drop max_vote
}
  
// rescale so votes sum to 1
bysort state year: egen sum_vote_share = total(vote_share)
gen vote_share_scale = vote_share/sum_vote_share

sort state year party_id


// Regressions
// OLS
reg vote_share_scale incumbent x_indiv
// OLS with white's SE
reg vote_share_scale incumbent x_indiv, vce(robust)
// OLS with cluster
reg vote_share_scale incumbent x_indiv, vce(cluster state)
// Non-linear
glm vote_share_scale incumbent x_indiv, family(binomial) link(logit)

// Panel method (have to use RE because our panel is set on the party level)
tsset party_id year
xtreg vote_share_scale incumbent x_indiv, vce(cluster state)
// With state fixed effects
xtreg vote_share_scale incumbent x_indiv i.state, vce(cluster state)


// Investigating win binary variable
bysort state year: egen max_vote = max(vote_share)
gen win = 0
replace win = 1 if vote_share == max_vote
drop max_vote

reg win incumbent x_indiv
probit win incumbent x_indiv
