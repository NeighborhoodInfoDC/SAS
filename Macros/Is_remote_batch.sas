/**************************************************************************
 Program:  Is_remote_batch.sas
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/28/15
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Autocall macro returns 1 if current SAS session is a
remote batch submit, 0 if local batch or interactive.

 Modifications:
**************************************************************************/

/** Macro Is_remote_batch - Start Definition **/

%macro Is_remote_batch( drive );

  %if %upcase(&drive) = %upcase(&_dcdata_r_drive) %then 1;
  %else 0;

%mend Is_remote_batch;

/** End Macro Definition **/
