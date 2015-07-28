/**************************************************************************
 Program:  Block10_to_anc02.sas
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/21/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Autocall macro to convert Census block IDs (2010) to
 DC ANCs (2002).

 Modifications:
**************************************************************************/

/** Macro Block10_to_anc02 - Start Definition **/

%macro Block10_to_anc02( invar=geoblk2010, outvar=Anc2002, format=Y );

  length &outvar $ 2;
  
  &outvar = put( &invar, $bk1an2f. );
  
  label &outvar = "Advisory Neighborhood Commission (2002)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $anc02a.;
  %end;

%mend Block10_to_anc02;

/** End Macro Definition **/

