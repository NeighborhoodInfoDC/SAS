/**************************************************************************
 Macro:    ConvertLibname
 Library:  
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  11/09/13
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Autocall macro to return local library name.

 Modifications:
**************************************************************************/

%macro ConvertLibname( inlib, type );

  %local outlib prename insuffix outsuffix;
  
  %** Check input parameter LIBRARY **;

  %if %length( &inlib ) < 3 or %length( &inlib ) > 8 %then %do;
    %err_mput( macro=ConvertLibname, msg=Must provide a valid library name (between 3-8 chars) as 1st macro parameter. INLIB=&inlib.. )
    %let outlib = ;
    %goto exit_macro;
  %end;
  
  %** Check input parameter TYPE **;

  %if %length( &type ) ~= 1 or %sysfunc( indexc( 'lrc', %lowcase( &type ) ) ) = 0 %then %do;
    %err_mput( macro=ConvertLibname, msg=Must provide a valid library type (L/R/C) as 2nd macro parameter. TYPE=&type.. )
    %let outlib = ;
    %goto exit_macro;
  %end;
  
  %let inlib = %lowcase( &inlib );
  %let outsuffix = _%lowcase( &type );
  
  %let insuffix = %sysfunc( reverse( %substr( %sysfunc( reverse( &inlib ) ), 1, 2 ) ) );
  
  %if &insuffix = &outsuffix %then %do;
    %let outlib = &inlib;
  %end;
  %else %if &insuffix = _l or &insuffix = _r or &insuffix = _c %then %do;
    %let outlib = %substr( &inlib, 1, %length( &inlib ) - 2 )&outsuffix;
  %end;
  %else %do;
  
    %** Create shortened library/filename prefix **;
    
    %if %length( &inlib ) > 6 %then %do;
      %let prename = %substr( &inlib, 1, 6 );
    %end;
    %else %do;
      %let prename = &inlib;
    %end;
    
    %let outlib = &prename&outsuffix;
    
  %end;
  
  %exit_macro:
  &outlib
  
%mend ConvertLibname;




/**********  UNCOMMENT TO TEST ****************

** Locations of SAS autocall macro libraries **;

filename uiautos  "K:\Metro\PTatian\UISUG\Uiautos";
options sasautos=(uiautos sasautos);

options mprint symbolgen mlogic;

%let r = %ConvertLibname( General, r );
%let l = %ConvertLibname( General, l );
%let c = %ConvertLibname( General, c );
%put General = &r &l &c;

%let r = %ConvertLibname( Genera_r, r );
%let l = %ConvertLibname( Genera_c, l );
%let c = %ConvertLibname( Genera_l, c );
%put Genera_r = &r &l &c;

%let r = %ConvertLibname( HomeSavr, r );
%let l = %ConvertLibname( HomeSavr, l );
%let c = %ConvertLibname( HomeSavr, c );
%put HomeSavr = &r &l &c;

%** Errors **;

%let r = %ConvertLibname( Ge, r );
%let r = %ConvertLibname( Generalissimo, r );
%let r = %ConvertLibname( General, f );
%let r = %ConvertLibname( General, remote );

%put _user_;

/***********************************************/
