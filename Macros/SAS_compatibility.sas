/**************************************************************************
 Macro:    SAS_compatibility
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

%macro SAS_compatibility(  );

  %if %sysevalf(&sysver >= 9.3) %then %do;
    options extendobscounter=no validmemname=compatible;
  %end;

%mend SAS_compatibility;



