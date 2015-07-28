/**************************************************************************
 Program:  Block10_to_anc12.sas
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/21/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Autocall macro to convert Census block IDs (2010) to
 DC ANCs (2012).

 Modifications:
**************************************************************************/

/** Macro Block10_to_anc12 - Start Definition **/

%macro Block10_to_anc12( invar=geoblk2010, outvar=Anc2012, format=Y );

  length &outvar $ 2;
  
  &outvar = put( &invar, $bk1anaf. );
  
  label &outvar = "Advisory Neighborhood Commission (2012)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $anc12a.;
  %end;

%mend Block10_to_anc12;

/** End Macro Definition **/

