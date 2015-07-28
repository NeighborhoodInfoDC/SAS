/**************************************************************************
 Program:  Block10_to_cluster_tr00.sas
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/21/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Autocall macro to convert Census block IDs (2010) to
 DC Neighborhood Clusters (tract-based, 2000).

 Modifications:
**************************************************************************/

/** Macro Block10_to_cluster_tr00 - Start Definition **/

%macro Block10_to_cluster_tr00( invar=geoblk2010, outvar=Cluster_tr2000, format=Y );

  length &outvar $ 2;
  
  &outvar = put( &invar, $bk1ct0f. );
  
  label &outvar = "Neighborhood cluster (tract-based, 2000)";
  
  %if %upcase( &format ) = Y %then %do;
    format &outvar $clus00a.;
  %end;

%mend Block10_to_cluster_tr00;

/** End Macro Definition **/

