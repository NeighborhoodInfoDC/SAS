/**************************************************************************
 Macro:    Block10_to_bg10
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/21/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Autocall macro to convert Census block IDs (2010) to
 block groups (2010).

 Modifications:
**************************************************************************/

/** Macro Block10_to_bg10 - Start Definition **/

%macro Block10_to_bg10( invar=geoblk2010, outvar=GeoBg2010, format=Y );

  length &outvar $ 12;
  
  &outvar = left( &invar );
  
  label &outvar = "Full census block group ID (2010): sscccttttttb";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $bg10a.;
  %end;

%mend Block10_to_bg10;

/** End Macro Definition **/

