/**************************************************************************
 Program:  Block10_to_psa04.sas
 Library:  
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/21/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Autocall macro to convert Census block IDs (2010) to
 DC PSAs (2004).

 Modifications:
**************************************************************************/

/** Macro Block10_to_psa04 - Start Definition **/

%macro Block10_to_psa04( invar=geoblk2010, outvar=Psa2004, format=Y );

  length &outvar $ 3;
  
  &outvar = put( &invar, $bk1ps4f. );
  
  label &outvar = "Police Service Area (2004)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $psa04a.;
  %end;

%mend Block10_to_psa04;

/** End Macro Definition **/

