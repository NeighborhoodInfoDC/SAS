/**************************************************************************
 Program:  Block00_to_bg00.sas
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  12/19/10
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Autocall macro to convert Census block IDs (2000) to
 block groups (2000).

 Modifications:
**************************************************************************/

/** Macro Block00_to_bg00 - Start Definition **/

%macro Block00_to_bg00( invar=geoblk2000, outvar=GeoBg2000, format=Y );

  length &outvar $ 12;
  
  &outvar = left( &invar );
  
  label &outvar = "Full census block group ID (2000): sscccttttttb";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $bg00a.;
  %end;

%mend Block00_to_bg00;

/** End Macro Definition **/
