/**************************************************************************
 Program:  Block00_to_anc02.sas
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/30/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Autocall macro to convert Census block IDs (2000) to
 DC ANCs (2002).

 Modifications:
**************************************************************************/

/** Macro Block00_to_anc02 - Start Definition **/

%macro Block00_to_anc02( invar=geoblk2000, outvar=Anc2002, format=Y );

  length &outvar $ 2;
  
  &outvar = put( &invar, $bk0an2f. );
  
  label &outvar = "Advisory Neighborhood Commission (2002)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $anc02a.;
  %end;

%mend Block00_to_anc02;

/** End Macro Definition **/

