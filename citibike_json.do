/****************************************************************************
* File name: citibike_json.do
* Author(s): Sze, J
* Date: 12/8/2018
* Description: Importing Citibike Station information from json
* 
*
* Inputs: 
* citi bike data feeds
*
* Outputs:
* ..\output_data\citibike_station.csv
* 
***************************************************************************/

insheetjson using "https://feeds.citibikenyc.com/stations/stations.json", showresponse

clear

// Need to create empty variables
gen str240 id = ""
gen str240 stationName = ""
gen str240 latitude = ""
gen str240 longitude = ""

insheetjson id stationName latitude longitude ///
using "https://feeds.citibikenyc.com/stations/stations.json", table("stationBeanList") columns("id" "stationName" "latitude" "longitude" )

compress

// Export into csv to load into QGIS
export delimited using "..\working_data\citibikestation.csv", replace

// Lets map the citi bike stations out in QGIS
