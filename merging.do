/****************************************************************************
* File name: merging.do
* Author(s): Sze, J
* Date: 12/8/2018
* Description: Building the Collisions dataset
* 
*
* Inputs: 
* ..\working_data\NYPD_Motor_Vehicle_Collisions_clean.dta
* Citibike Station to Collision Data
* NOAA Weather
* Outputs:
* ..\working_data\collision_monthly.dta
***************************************************************************/
use "..\working_data\NYPD_Motor_Vehicle_Collisions_clean.dta",clear
notes list

// How to merge
help mmerge

// Merging in Nearest Citibike station to Collisions data
/*
mmerge /*replace with unique identifier*/ using "/***filepath_filename***/", ///
type(1:1) ///
unmatched(master) ///
ukeep()

rename hubname citistation_id
rename hubdist citistation_to_collision_dist
label variable citistation_id "ID of nearest CitiBike station"
label variable citistation_to_collision_dist "Dist. of nearest CitiBike station to collision"

// Determine if collisions that are close to an CitiBike station
sum citistation_to_collision_dist, detail
sum citistation_to_collision_dist if citistation_to_collision_dist < r(p75), detail
gen citibikezone = citistation_to_collision_dist < 500
*/

// If we want to run our analysis by month
// Use collapse function
help collapse

// Create month variable
// This is easily done because date is recognized by stata
gen month = month(date)

// Year variable was previously created
tab year

// Create a variable to be counted
gen count = 1 

// Think of this like a pivot table in excel
collapse ///
(count) collision_count = count ///
(sum) cyclistinjured cyclistkilled ///
, by(ID month year)

// Merge in Weather data from NOAA
mmerge month year using "..\working_data\NOAA_central_park_station.dta", ///
type(n:1) ///
unmatched(master) ///
ukeep(monthly_avg_drybulbtemp)

// Are there any issues with the merge?


save "..\working_data\collision_monthly.dta",replace
