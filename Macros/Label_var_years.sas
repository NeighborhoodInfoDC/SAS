/**************************************************************************
 Program:  Label_var_years.sas
 Library:  Macro library
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  10/25/12
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Autocall macro to label a series of variables
 across multiple years.

 Modifications:
**************************************************************************/

/** Macro Label_var_years - Start Definition **/

%macro Label_var_years( var=, years=, from=, to=, label= );

  %local i y y_lbl;
  
  %if &years ~= %then %do;
  
    %** List of years (nonsequential) **; 
  
    %let i = 1;
    %let y = %scan( &years, &i );
    
    %do %while ( &y ~= );

      %let y_lbl = %sysfunc( translate( &y, '-', '_' ) );
      
      %if %length( &label ) ~= 0 %then %do;
        label &var._&y = "&label, &y_lbl";
      %end;
      %else %do;
        label &var._&y = "&y_lbl";
      %end;
       
      %let i = %eval( &i + 1 );
      %let y = %scan( &years, &i );

    %end;
  
  %end;
  %else %if &from ~= and &to ~= %then %do;
  
    %** Sequential years **;

    %do y = &from %to &to;
  
      %if %length( &label ) ~= 0 %then %do;
        label &var._&y = "&label, &y";
      %end;
      %else %do;
        label &var._&y = "&y";
      %end;

    %end;

  %end;  
  %else %do;
    %err_mput( macro=Label_var_years, msg=Must specify values for either YEARS= or FROM=/TO=. )
  %end;
  
%mend Label_var_years;

/** End Macro Definition **/


/**************  UNCOMMENT TO TEST **************

options mprint symbolgen mlogic;

** Locations of SAS autocall macro libraries **;

filename uiautos  "K:\Metro\PTatian\UISUG\Uiautos";
filename dcautos  "K:\Metro\PTatian\DCData\SAS\Macros";
options sasautos=(dcautos uiautos sasautos);

data A;

  Num_2000 = 5;
  Num_2001 = 6;
  Num_2002 = 7;

  Num_2005_09 = 10;

  %Label_var_years( var=Num, years=2000 2001 2002 2005_09, from=, to=, label=Numerator )
  
run;

proc contents data=A;

run;

/****************************************************/
