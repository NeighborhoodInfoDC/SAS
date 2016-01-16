/**************************************************************************
 Macro:    Tr10_to_eor
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  05/04/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Autocall macro to convert 2010 tract ID to EOR ID.

 Modifications:
**************************************************************************/

/** Macro Tr10_to_eor - Start Definition **/

%macro Tr10_to_eor( tract=Geo2010, eor=Eor );

  length &eor $ 1;
  
  &eor = put( &tract, $tr1eor. );
  
  label &eor = "East of the Anacostia River";
  
  format &eor $eor.;

%mend Tr10_to_eor;

/** End Macro Definition **/

