/**************************************************************************
 Program:  Set_mrecall.sas
 Library:  Macro library
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  09/07/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Autocall macro to set MRECALL option based on value of
 _PROGRAM macro var.

 Modifications:
**************************************************************************/

/** Macro Set_mrecall - Start Definition **/

%macro Set_mrecall;

  %if &_program = {Interactive} %then %do;
    options mrecall;
  %end;
  %else %do;
    options nomrecall;
  %end;

%mend Set_mrecall;

/** End Macro Definition **/

