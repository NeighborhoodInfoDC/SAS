/**************************************************************************
 Program:  GeoBlk2000_Octo.sas
 Library:  Octo
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/21/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Autocall macro to convert NeighborhoodInfo DC standard 
 var GeoBlk2000 to OCTO census block ID (cjrTractBl).

 Modifications:
**************************************************************************/

/** Macro GeoBlk2000_Octo - Start Definition **/

%macro GeoBlk2000_Octo( outvar=cjrTractBl, invar=GeoBlk2000 );

  length &outvar $ 254;

  if &invar ~= "" then do;
    
    &outvar = trim( left( put( 1 * substr( &invar, 6, 6 ), 6. ) ) ) || ' ' ||
              substr( &invar, 12, 4 );
    
  end;

  label
    &outvar = "OCTO census block ID (2000)";
    
%mend GeoBlk2000_Octo;

/** End Macro Definition **/

