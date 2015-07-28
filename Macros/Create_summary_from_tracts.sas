/**************************************************************************
 Program:  Create_summary_from_tracts.sas
 Library:  General
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/29/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Autocall macro to create geographic summary data set
 from a tract summary data set for the specified geography.

 Modifications:
  09/26/06  Added LIB= parameter.
  11/21/06  Modify SORTEDBY= option for output data set.
  12/08/06  Changed $GEOLBL to $GEODLBL.
  12/22/10 PAT Added MPRINT= parameter.
  02/24/11 PAT Added declaration for local macro vars.
  07/14/12 PAT Added TRACT_YR= parameter for specifying source tract year.
**************************************************************************/

/** Macro Create_summary_from_tracts - Start Definition **/

%macro Create_summary_from_tracts( 
  geo=, 
  lib=,
  data_pre=,
  data_label=,
  count_vars=, 
  prop_vars=,
  calc_vars=,
  calc_vars_labels=,
  tract_yr=,
  register=, 
  creator_process=,
  restrictions=,
  revisions=,
  mprint=n
);

  %local wtfile geosuf geodlbl geofmt tractid;

  %let geo = %upcase( &geo );
  %let register = %upcase( &register );
  
  %if &tract_yr = 2000 %then %do;
    %let tractid = Geo2000;
    %let wtfile = %sysfunc( putc( &geo, $geotw0f. ) );
  %end;
  %else %if &tract_yr = 2010 %then %do;
    %let tractid = Geo2010;
    %let wtfile = %sysfunc( putc( &geo, $geotw1f. ) );
  %end;
  %else %do;
    %err_mput( macro=Create_summary_from_tracts, 
               msg=Must specify source tract year as 2000 or 2010: TRACT_YR=&tract_yr.. )
    %note_mput( macro=Create_summary_from_tracts, msg=Macro exiting. )
    %goto exit_macro;
  %end;
  
  %if %sysfunc( putc( &geo, $geoval. ) ) ~= %then %do;
    %let geosuf = %sysfunc( putc( &geo, $geosuf. ) );
    %let geodlbl = %sysfunc( putc( &geo, $geodlbl. ) );
    %let geofmt = %sysfunc( putc( &geo, $geoafmt. ) );
  %end;
  %else %do;
    %err_mput( macro=Create_summary_from_tracts, 
               msg=Invalid or missing value of GEO= parameter: GEO=&geo.. )
    %note_mput( macro=Create_summary_from_tracts, msg=Macro exiting. )
    %goto exit_macro;
  %end;

  %note_mput( macro=Create_summary_from_tracts, 
              msg=Creating &geo level data from &tract_yr census tracts. )

  %Transform_geo_data(
      dat_ds_name=%if &tract_yr = 2000 %then &lib..&data_pre._tr00;
		%else %if &tract_yr = 2010 %then &lib..&data_pre._tr10;,
      dat_org_geo=&tractid,
      dat_count_vars=&count_vars,
      dat_prop_vars=&prop_vars,
      wgt_ds_name=General.&wtfile,
      wgt_org_geo=&tractid,
      wgt_new_geo=&geo,
      wgt_new_geo_fmt=&geofmt,
      wgt_id_vars=,
      wgt_count_var=popwt,
      wgt_prop_var=popwt_prop,
      out_ds_name=&lib..&data_pre.&geosuf,
      out_ds_label=%quote(&data_label, &geodlbl),
      calc_vars=&calc_vars,
      calc_vars_labels=&calc_vars_labels,
      keep_nonmatch=N,
      show_warnings=10,
      print_diag=Y,
      full_diag=N,
      mprint=&mprint
    )
  
  proc datasets library=&lib memtype=(data) nolist;
    modify &data_pre.&geosuf (sortedby=&geo);
  quit;

  %File_info( data=&lib..&data_pre.&geosuf, printobs=0 )
  
  %** Register metadata **;
  
  %if &register = Y %then %do;
    %Dc_update_meta_file(
      ds_lib=&lib,
      ds_name=&data_pre.&geosuf,
      creator_process=&creator_process,
      restrictions=&restrictions,
      revisions=%quote(&revisions)
    )
  %end;
  
  %exit_macro:

%mend Create_summary_from_tracts;

/** End Macro Definition **/

