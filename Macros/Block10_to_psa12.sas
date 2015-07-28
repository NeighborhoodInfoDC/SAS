/**************************************************************************
 Program:  Block10_to_psa12.sas
 Library:  
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/21/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Autocall macro to convert Census block IDs (2010) to
 DC PSAs (2012).

 Modifications:
**************************************************************************/

/** Macro Block10_to_psa12 - Start Definition **/

%macro Block10_to_psa12( invar=geoblk2010, outvar=Psa2012, format=Y );

  length &outvar $ 3;
  
  &outvar = put( &invar, $bk1psaf. );
  
  label &outvar = "Police Service Area (2012)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $psa12a.;
  %end;

%mend Block10_to_psa12;

/** End Macro Definition **/

