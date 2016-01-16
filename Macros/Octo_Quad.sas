/**************************************************************************
 Macro:    Octo_Quad
 Library:  Octo
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  04/11/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Autocall macro to convert OCTO quadrant ID to
 NeighborhoodInfo DC standard var Quad.

 Modifications:
**************************************************************************/

/** Macro Octo_Quad - Start Definition **/

%macro Octo_Quad( invar=Quadrant, outvar=Quad );

  length &outvar $ 2;
  
  &outvar = left( upcase( &invar ) );
  
  if &outvar not in ( 'NW', 'NE', 'SW', 'SE' ) then &outvar = '';

  label
    &outvar = "DC quadrant";
    
%mend Octo_Quad;

/** End Macro Definition **/

