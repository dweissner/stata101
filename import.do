/****************************************************************************
* File name: import.do
* Author(s): Sze, J
* Date: 12/8/2018
* Description: Importing NYPD Collision datasets
* 
*
* Inputs: 
* NYC Open Data NYPD Data
*
* Outputs:
* ..\input_data\NYPD_Motor_Vehicle_Collisions.dta
* 
***************************************************************************/

clear
import delimited "https://data.cityofnewyork.us/api/views/h9gi-nx95/rows.csv?accessType=DOWNLOAD"
display "$S_DATE $S_TIME"
notes: "Downloaded $S_DATE $S_TIME"
notes list
save "..\input_data\NYPD_Motor_Vehicle_Collisions.dta",replace

