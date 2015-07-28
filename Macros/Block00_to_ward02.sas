/**************************************************************************
 Program:  Block00_to_ward02.sas
 Library:  
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/30/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Autocall macro to convert Census block IDs (2000) to
 DC wards (2002).

 Modifications:
**************************************************************************/

/** Macro Block00_to_ward02 - Start Definition **/

%macro Block00_to_ward02( invar=geoblk2000, outvar=Ward2002, format=Y );

  length &outvar $ 1;
  
  &outvar = put( &invar, $bk0wd2f. );
  
  label &outvar = "Ward (2002)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $ward02a.;
  %end;

%mend Block00_to_ward02;

/** End Macro Definition **/

