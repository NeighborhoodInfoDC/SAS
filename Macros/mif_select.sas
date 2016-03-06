/**************************************************************************
 Macro:  mif_select.sas
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/05/16
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Returns <a> if <condition> is true, <b> if false.

 Modifications:
**************************************************************************/

%macro mif_select( 
  condition,      /** Macro value or expression that resolves to a logical condition. Conditions containing = must be enclosed in parentheses, ex, (a=a). **/
  a,              /** Return value if condition is true **/
  b               /** Return value if condition is false **/
  );

  %if %eval(&condition) %then %do;
    &a
  %end;
  %else %do;
    &b
  %end;

%mend mif_select;

/************************ UNCOMMENT TO TEST ***************************

%let ret = %mif_select( 1, TRUE, FALSE );
%put RET=&RET;

%let ret = %mif_select( 0, TRUE, FALSE );
%put RET=&RET;

%let ret = %mif_select( (a=a), TRUE, FALSE );
%put RET=&RET;

%let ret = %mif_select( (a=b), TRUE, FALSE );
%put RET=&RET;

%let ret = %mif_select( (2+2=4), TRUE, FALSE );
%put RET=&RET;

%let ret = %mif_select( (2+2=5), TRUE, FALSE );
%put RET=&RET;

/**********************************************************************/
