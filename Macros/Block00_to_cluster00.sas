/**************************************************************************
 Program:  Block00_to_cluster00.sas
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/30/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Autocall macro to convert Census block IDs (2000) to
 DC Neighborhood Clusters (2000).

 Modifications:
**************************************************************************/

/** Macro Block00_to_cluster00 - Start Definition **/

%macro Block00_to_cluster00( invar=geoblk2000, outvar=Cluster2000, format=Y );

  length &outvar $ 2;
  
  &outvar = put( &invar, $bk0cl0f. );
  
  label &outvar = "Neighborhood cluster (2000)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $clus00a.;
  %end;

%mend Block00_to_cluster00;

/** End Macro Definition **/

