/**************************************************************************
 Program:  SAS_compatibility.sas
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  12/03/15
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Autocall macro sets backward compatibility system options 
 for later versions of SAS.

 Modifications:
**************************************************************************/

/** Macro SAS_compatibility - Start Definition **/

%macro SAS_compatibility(  );

  %if %sysevalf(&sysver >= 9.3) %then %do;
    options extendobscounter=no validmemname=compatible;
  %end;

%mend SAS_compatibility;

/** End Macro Definition **/

