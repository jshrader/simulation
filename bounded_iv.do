// My Setting
clear
set obs 1000
gen e_d = rnormal()
gen z = rnormal()
gen a = rnormal()
gen dist = -a + z + e_d
gen e_s = rnormal()
gen s = -dist + a + e_s

reg s dist
reg s dist a

// z is a perfect instrument, like randomized trial assingment
ivregress gmm s (dist = e_d)
ivregress gmm s (dist = z)
ivregress gmm s (dist = z e_d)

// now consider the case where we have a bounding instrument
gen dist2 = -a + e_d
gen ub = rnormal() + 1
gen gap = runiform()*3
gen lb = ub - gap
gen dist2_z = dist2
replace dist2_z = ub if dist2_z > ub
replace dist2_z = lb if dist2_z < lb

gen s2 = -dist2_z + a + e_s

reg s2 dist2_z
reg s2 dist2_z a

ivregress gmm s2 (dist2_z = e_d), first
ivregress gmm s2 (dist2_z = ub)
ivregress gmm s2 (dist2_z = lb)
// So we see that the bounding works as an instrument directly. Interestingly
// the e_d variable no longer works. The exogeneity has not changed, but the
// functional form has.
ivregress gmm s2 (dist2_z = ub lb)

// We can also identify the true value by limiting the sample
reg s2 dist2_z if dist2_z == lb | dist2_z == ub
corr dist2_z a
corr dist2_z a if dist2_z == lb
corr dist2_z a if dist2_z == ub
/// Although this starts to fail pretty dramatically when the number of
  // truncated observations falls

// Curiously, including lb/ub and the gap gives very sensical values if
// you add appropriately...
reg s2 ub gap
reg s2 lb gap
// Is this a real ID or just an artifact of my simulation?



// Balke and Pearl model
clear
set obs 100
gen e_d = rnormal()
gen z = rnormal()
gen u = rnormal()
gen d = u + z + e_d
gen e_y = rnormal()
gen y = d + u + e_y

reg y d
