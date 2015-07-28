/**************************************************************************
 Program:  Tr00_to_eor.sas
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/01/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Autocall macro to convert tract ID to EOR ID.

 Modifications:
**************************************************************************/

/** Macro Tr00_to_eor - Start Definition **/

%macro Tr00_to_eor( tract=Geo2000, eor=Eor );

  length &eor $ 1;
  
  &eor = put( &tract, $tr0eor. );
  
  label &eor = "East of the Anacostia River";
  
  format &eor $eor.;

%mend Tr00_to_eor;

/** End Macro Definition **/

