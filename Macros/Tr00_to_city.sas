/**************************************************************************
 Program:  Tr00_to_city.sas
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/23/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Autocall macro to convert tract ID to city ID.

 Modifications:
**************************************************************************/

/** Macro Tr00_to_city - Start Definition **/

%macro Tr00_to_city( tract=Geo2000, city=city );

  length &city $ 1;
  
  &city = put( &tract, $tr0city. );
  
  label &city = "Washington, D.C.";
  
  format &city $city.;

%mend Tr00_to_city;

/** End Macro Definition **/
