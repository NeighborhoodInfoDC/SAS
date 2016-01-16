/**************************************************************************
 Macro:    Pct_calc
 Library:  Profiles
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  04/01/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Autocall macro to calculate percentages or rates
 across multiple years.

 Modifications:
  02/20/08 PAT Added round= parameter (specify rounding unit).
               If denominator = 0, set percentage to .I.
  05/08/08 PAT Added year_only_lbl= to specify year only label.
  07/25/08 PAT Fixed problem with year_only_lbl= not working for
               sequential years.
  02/24/11 PAT Added declaration for local macro vars.
  08/03/11 PAT Change "_" to "-" in years= for variable labels.
               Set mult= to 1 if missing.
**************************************************************************/

%macro Pct_calc( var=, num=, den=, cons_den=, years=, from=, to=, mult=100, label=, year_only_lbl=N, round=, missval=.i );

  %local i y y_lbl;
  
  %if &mult = %then %let mult = 1;

  %if &years ~= %then %do;
  
    %** List of years (nonsequential) **; 
  
    %let i = 1;
    %let y = %scan( &years, &i );
    
    %do %while ( &y ~= );

      %let y_lbl = %sysfunc( translate( &y, '-', '_' ) );
      
      %if &den ~= %then %do;
        if &den._&y > 0 then &var._&y = (&mult) * ( &num._&y / &den._&y );
        else &var._&y = &missval;
      %end;
      %else %do;
        if &cons_den > 0 then &var._&y = (&mult) * ( &num._&y / &cons_den );
        else &var._&y = &missval;
      %end;
      
      %if &round ~= %then %do;
        &var._&y = round( &var._&y, &round );
      %end;
      
      %if %length( &label ) ~= 0 %then %do;
        label &var._&y = "&label, &y_lbl";
      %end;
      %else %if %upcase( &year_only_lbl ) = Y %then %do;
        label &var._&y = "&y_lbl";
      %end;
       
      %let i = %eval( &i + 1 );
      %let y = %scan( &years, &i );

    %end;
  
  %end;
  %else %if &from ~= and &to ~= %then %do;
  
    %** Sequential years **;

    %do y = &from %to &to;
  
      %if &den ~= %then %do;
        if &den._&y > 0 then &var._&y = (&mult) * ( &num._&y / &den._&y );
        else &var._&y = &missval;
      %end;
      %else %do;
        if &cons_den > 0 then &var._&y = (&mult) * ( &num._&y / &cons_den );
        else &var._&y = &missval;
      %end;

      %if &round ~= %then %do;
        &var._&y = round( &var._&y, &round );
      %end;
      
      %if %length( &label ) ~= 0 %then %do;
        label &var._&y = "&label, &y";
      %end;
      %else %if %upcase( &year_only_lbl ) = Y %then %do;
        label &var._&y = "&y";
      %end;

    %end;

  %end;  
  %else %do;
    %err_mput( macro=Pct_calc, msg=Must specify values for either YEARS= or FROM=/TO=. )
  %end;
  
%mend Pct_calc;




/**************  UNCOMMENT TO TEST **************

options mprint symbolgen mlogic;

** Locations of SAS autocall macro libraries **;

filename uiautos  "K:\Metro\PTatian\UISUG\Uiautos";
filename dcautos  "K:\Metro\PTatian\DCData\SAS\Macros";
options sasautos=(dcautos uiautos sasautos);

data A;

  Num_2000 = 5;
  Den_2000 = 100;

  Num_2005_09 = 10;
  Den_2005_09 = 100;

  %Pct_calc( var=Pct, num=Num, den=Den, cons_den=, years=2000 2005_09, from=, to=, mult=, label=Percentage, year_only_lbl=N, round=, missval=.i )
  
run;

proc contents data=A;

proc print data=A;

run;

/****************************************************/
