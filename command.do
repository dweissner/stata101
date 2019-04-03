/****************************************************************************
* File name: command.do
* Author(s): Sze, J
* Date: 12/8/2018
* Description: 
* 
*
* Inputs: 
* 
* Outputs:
* 
***************************************************************************/

// Install some user written packages
do "install.do"

// Import the NYPD Collisions data
do "import.do"

// Import Citibike data from json
do "citibike_json.do"

// Import NOAA Csv into dta
// clean and created monthly average data
do "convert_NOAA.do"

// Read the NYPD Collisions dta
// Clean and create new variables
do "cleaning.do"

// Merge in weather data from NOAA to NYPD cleaned data
do "merging.do"
