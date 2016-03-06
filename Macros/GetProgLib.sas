/************************************************************************
  Macro:    GetProgLib
  Library:  Macros
  Project:  NeighborhoodInfo DC
  Author:   P. Tatian
  Created:  8/18/04
  Version:  SAS 8.12 (Windows version)
  
  Description: Return the library of the currently 
    submitted SAS program to the global macro variable given by VAR.  
    If running in interactive mode, macro returns an empty string.

  Modifications:
   02/24/11 PAT Renamed and added declaration for local macro vars.
   12/04/12 PAT Added check for DCData K: path. 
   11/02/13 PAT Revised for use with new SAS server setup.
 ************************************************************************/

%macro GetProgLib( var );

  %global &var;
  
  %local _FullName _index _len _LibName;
  
  %if &_remote_session %then %do;
  
    %if %substr( &SYSPROCESSNAME, 1, 7 ) = Program %then %do;
    
    %let _FullName = %substr( &SYSPROCESSNAME, 10, %length( &SYSPROCESSNAME ) - 10 );

        %let _index = %index( %upcase(&_FullName), %upcase(&_dcdata_r_path) );
        %if &_index > 0 %then %do;
          %let _len = %length( &_dcdata_r_path );
          %let _LibName = %substr( &_FullName, &_index + &_len + 1 );
          %let &var = %upcase( %substr( &_LibName, 1, %index( &_LibName, \ ) - 1 ) );
        %end;
        %else %do;
          %let &var = ;
        %end;
    %end;
    %else %do;
      %let &var = ;
    %end;
  
  %end;
  %else %do;

    %let _FullName = %sysfunc( getoption( sysin ) );
    
    %if %length( &_FullName ) > 0 %then %do;
    
      %let _index = %index( %upcase(&_FullName), %upcase(&_dcdata_l_path) );    
    
      %if &_index > 0 %then %do;
        %let _len = %length( &_dcdata_l_path );
        %let _LibName = %substr( &_FullName, &_index + &_len + 1 );
        %let &var = %upcase( %substr( &_LibName, 1, %index( &_LibName, \ ) - 1 ) );
      %end;
      %else %do;
        %let _index = %index( %upcase(&_FullName), %upcase(&_dcdata_r_path) );
        %if &_index > 0 %then %do;
          %let _len = %length( &_dcdata_r_path );
          %let _LibName = %substr( &_FullName, &_index + &_len + 1 );
          %let &var = %upcase( %substr( &_LibName, 1, %index( &_LibName, \ ) - 1 ) );
        %end;
        %else %do;
          %let &var = ;
        %end;
      %end;

    %end;
    %else %do;
      %let &var = ;
    %end;
    
  %end;

%mend GetProgLib;


