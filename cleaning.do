/****************************************************************************
* File name: cleaning.do
* Author(s): Sze, J
* Date: 12/8/2018
* Description: Cleaning raw data from NYPD Collisions Dataset
* 
*
* Inputs: 
* ..\input_data\NYPD_Motor_Vehicle_Collisions
*
* Outputs:
* ..\working_data\NYPD_Motor_Vehicle_Collisions_clean.dta
***************************************************************************/

use "..\input_data\NYPD_Motor_Vehicle_Collisions",clear
notes list

// How to format date?
help datetime
// preview the date in the data editor
// is the date in string format?
// is date in some other date formats?
sum date
codebook date

// Formating
order(uniquekey), before(date)
gen date2 = date(date, "MDY"),after(date)
format date2 %td
drop date
rename date2 date

gen time2 = clock(time, "hm"),after(time)
format time2 %tc
drop time
rename time2 time

// Explore the new date variable
sum date, format
sum time, format

// Rename long names
rename numberofcyclistinjured cyclistinjured
rename numberofcyclistkilled cyclistkilled


// Identify Bicycle related collisions
gen bicyclerelated = ///
vehicletypecode1 == "BICYCLE" | ///
vehicletypecode2 == "BICYCLE" | ///
vehicletypecode3 == "BICYCLE" | ///
vehicletypecode4 == "BICYCLE" | ///
vehicletypecode5 == "BICYCLE" | ///
vehicletypecode1 == "PEDICAB" | ///
vehicletypecode2 == "PEDICAB" | ///
vehicletypecode3 == "PEDICAB" | ///
vehicletypecode4 == "PEDICAB" | ///
vehicletypecode5 == "PEDICAB"

// Explore the coodinates
codebook latitude
codebook longitude

// There are missing data in the latitude and longitude
gen mi_latlong = mi(latitude) & mi(longitude)

// Create year variable
gen year = year(date)

// Explore the data
tab mi_latlong year, column


// Fill in the missing Longditude and Latitude points

// Sort the data in order
sort onstreetname crossstreetname 

// If borough, zip, on street and cross street are the same 
// we use the latitude & longitude for the missing

replace latitude = latitude[_n-1] if ///
mi(latitude) & ///
(borough == borough[_n-1]) & ///
(zipcode == zipcode[_n-1]) & ///
(onstreetname == onstreetname[_n-1]) & ///
(crossstreetname ==  crossstreetname[_n-1])

replace longitude = longitude[_n-1] if ///
mi(longitude) & ///
(borough == borough[_n-1]) & ///
(zipcode == zipcode[_n-1]) & ///
(onstreetname == onstreetname[_n-1]) & ///
(crossstreetname ==  crossstreetname[_n-1])

gen mi_latlong2 = mi(latitude) & mi(longitude)
tab mi_latlong2 year, column

// Decision to make
// Do we drop observations that do not have coordinates, or geocode them through
// other means?

// Drop observations which are still missing
drop if mi_latlong2 == 1

// Out of boundaries
drop if longitude < -74.5 | longitude > -73
drop if latitude < 40 |  latitude > 41

// Lets visualize the collisions
twoway scatter latitude longitude, msymbol(o) msize(tiny)
graph close

// Create unique ID for unique longitude and latitude
egen ID = group( latitude longitude)

// Which intersections have the most collisions?

// Which intersections have the most collisions in 2013?


// Export for QGIS maping
export delimited using "..\working_data\NYPD_Motor_Vehicle_Collisions_clean.csv", replace

// Lets map the collisions out in QGIS


display "$S_DATE $S_TIME"
notes: "Cleaned $S_DATE $S_TIME"
notes list
save "..\working_data\NYPD_Motor_Vehicle_Collisions_clean.dta",replace



