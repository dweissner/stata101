/****************************************************************************
* File name: convert_NOAA.do
* Author(s): Sze, Jeremy
* Date: 8/24/2018
* Description: 
* Extracts information for the Raw NOAA Central Park data
*
* Inputs: 
*
* 
* Outputs:
* 
***************************************************************************/

import delimited "..\input_data\NOAA_Central_park_station.csv",clear

destring, replace
rename date datetime
gen date = date(datetime, "YMD#"), after(datetime)
format date %td

keep if reporttpye == "SOD" | datetime == "2017-01-11 23:59" | datetime == "2017-01-17 23:59"

gen day = day(date)
gen month = month(date)
gen year = year(date)

destring dailyprecip,force replace
destring dailysnowfall, force replace
collapse (mean) monthly_avg_drybulbtemp = dailyaveragedrybulbtemp monthly_avg_precip = dailyprecip monthly_avg_snowfall =dailysnowfall ///
(sum)  monthly_tot_drybulbtemp = dailyaveragedrybulbtemp monthly_tot_precip = dailyprecip monthly_tot_snowfall =dailysnowfall, by(month year) 

save "..\working_data\NOAA_central_park_station.dta",replace
