/**************************************************************************
 Macro:    Block10_to_tr10
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/21/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Autocall macro to convert Census block IDs (2010) to
 Census tracts (2010).

 Modifications:
**************************************************************************/

/** Macro Block10_to_tr10 - Start Definition **/

%macro Block10_to_tr10( invar=geoblk2010, outvar=Geo2010, format=Y );

  length &outvar $ 11;
  
  &outvar = left( &invar );
  
  label &outvar = "Full census tract ID (2010): ssccctttttt";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $geo10a.;
  %end;

%mend Block10_to_tr10;

/** End Macro Definition **/

