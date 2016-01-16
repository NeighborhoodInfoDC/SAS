/**************************************************************************
 Macro:    Block00_to_psa12
 Library:  
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/21/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Autocall macro to convert Census block IDs (2000) to
 DC PSAs (2012).

 Modifications:
  08/28/12 PAT Corrected block to geo format name. 
**************************************************************************/

/** Macro Block00_to_psa12 - Start Definition **/

%macro Block00_to_psa12( invar=geoblk2000, outvar=Psa2012, format=Y );

  length &outvar $ 3;
  
  &outvar = put( &invar, $bk0psaf. );
  
  label &outvar = "Police Service Area (2012)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $psa12a.;
  %end;

%mend Block00_to_psa12;

/** End Macro Definition **/

