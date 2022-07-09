/**************************************************************************
 Macro:  Archive_data_sets.sas
 Library:  PresCat
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/27/15
 Version:  SAS 9.2
 Environment:  -
 
 Description:  Autocall macro to archive DCData data sets.
 
 Note: Overwrite=N (default) prevents replacement of older files in a 
 previously existing archive. 

 Modifications:
**************************************************************************/

/** Macro Archive_data_sets - Start Definition **/

%macro Archive_data_sets( 
  data=,     /** List of data set names (required) **/
  lib=,      /** Data set library (required) **/
  zip_suf=,  /** Suffix for ZIP file name **/
  zip_pre=,  /** Prefix for ZIP file name (if missing current datetime is used) **/
  path=&_dcdata_r_path,   /** Library path **/
  overwrite=n,  /** Overwrite older files in archive **/
  zip_program= %str(""&_dcdata_r_drive:\Tools\7-zip\7z"")  /** Location of 7z program **/,
  quiet=n  /** Suppress messages **/
  );

  %local i v update_switches;
  
  %** Check parameters **;
  
  %if %length( &data ) = 0 %then %do;
    %err_mput( macro=Archive_data_sets, msg=Data set list not specified (data=). )
    %goto exit;
  %end;

  %if %length( &lib ) = 0 %then %do;
    %err_mput( macro=Archive_data_sets, msg=Library not specified (lib=). )
    %goto exit;
  %end;
  
  %if not %DirExist( &path\&lib ) %then %do;
    %err_mput( macro=Archive_data_sets, msg=Library specified does not exist (lib=%upcase(&lib)). )
    %goto exit;
  %end;
  
  %if %mparam_is_yes( &overwrite ) %then %do;
    %let update_switches = ;
    %if not %mparam_is_yes( &quiet ) %then %do;
      %note_mput( macro=Archive_data_sets, 
                  msg=%str(Overwrite=%upcase( &overwrite ) specified, older files in existing archive WILL be replaced.) )
    %end;
  %end;
  %else %do;
    %let update_switches = -uy1z1;  %** Copy previously saved older files to new archive **;
    %if not %mparam_is_yes( &quiet ) %then %do;
      %note_mput( macro=Archive_data_sets, 
                  msg=%str(Overwrite=%upcase( &overwrite ) specified, older files in existing archive will NOT be replaced.) )
    %end;
  %end;
  
  %if &zip_pre = %then 
    %let zip_pre = %sysfunc( putn( %sysfunc( datetime() ), b8601dt19.0 ) );
    
  %let i = 1;
  %let v = %scan( &data, &i, %str( ) );

  %do %until ( &v = );

    %if %Dataset_exists( %ConvertLibname(&lib,r).&v ) %then %do;
      x "&zip_program a &update_switches -tzip &path\&lib\Data\Archive\&zip_pre.&zip_suf &path\&lib\Data\&v..sas7bdat";
    %end;
    %else %do;
      %warn_mput( macro=Archive_data_sets, msg=Data set %str(%upcase(&lib..&v)) does not exist. )
    %end;

    %let i = %eval( &i + 1 );
    %let v = %scan( &data, &i, %str( ) );

  %end;

  %exit:

%mend Archive_data_sets;

/** End Macro Definition **/


/******************** UNCOMMENT FOR TESTING ***********************************

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Test )


%Archive_data_sets()

%Archive_data_sets( data=X )

%Archive_data_sets( data=X, lib=Y )

%Archive_data_sets( data=X, lib=Test )

%Archive_data_sets( data=Geo2010 acs_2007_11_sum_tr_anc02 test_r, lib=Test )

%Archive_data_sets( data=Geo2010 acs_2007_11_sum_tr_anc02 test_r, lib=Test, zip_pre=Test )

%Archive_data_sets( data=Geo2010, lib=Test, zip_pre=Test )

%Archive_data_sets( data=Geo2010, lib=Test, zip_pre=Test, overwrite=y )

run;

/******************** END TESTING *********************************************/
