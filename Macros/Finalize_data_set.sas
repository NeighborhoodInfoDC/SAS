/**************************************************************************
 Program:  Finalize_data_set.sas
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  11/05/16
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Autocall macro to finalize SAS data set in DCData.

 Modifications:
**************************************************************************/

/** Macro Finalize_data_set - Start Definition **/

%macro Finalize_data_set( 
  /** Finalize data set parameters **/
  data=,      /** Input temporary data set (required) **/
  out=,       /** Ouput data set name (required) **/
  outlib=,    /** Output data set library (required) **/
  label=,     /** Output data set label, in quotes (required) **/
  sortby=,    /** Output data set sorting variables (required) **/
  archive=N,  /** Add output data set to archive (Y/N) **/
  archive_name=,  /** Name of data set archive (default is batch submit program name) **/
  /** Metadata parameters **/
  register_metadata=Y,        /** Register file with metadata system (Y/N) **/
  creator_process=&_program,  /** Metadata creator process (default is batch submit program name) **/
  restrictions=None,          /** Metadata file restrictions **/
  revisions=,                 /** Metadata file revisions (required) **/
  /** File info parameters **/
  contents=Y,                 /** Print data set Proc Contents (Y/N) **/
  printobs=10,                /** Number of data set observations to print **/
  printchar=N,                /** Print character vars only (Y/N) **/
  printvars=,                 /** Data set vars to print (default is all) **/
  freqvars=,                  /** Data set vars for frequency tables (default is none) **/
  stats=n sum mean stddev min max    /** Descriptive statistics **/
  );

  %note_mput( macro=Finalize_data_set, msg=Starting macro. )

  %** Check parameters **;
  
  %if %length( &data ) = 0 %then %do;
    %err_mput( macro=Finalize_data_set, msg=Input data set not specified (data=). )
    %goto exit;
  %end;
  
  %if %length( &out ) = 0 %then %do;
    %err_mput( macro=Finalize_data_set, msg=Output data set not specified (out=). )
    %goto exit;
  %end;

  %if %length( &outlib ) = 0 %then %do;
    %err_mput( macro=Finalize_data_set, msg=Output library not specified (outlib=). )
    %goto exit;
  %end;
  
  %if %length( &label ) = 0 %then %do;
    %err_mput( macro=Finalize_data_set, msg=Output data set label not specified (label="..."). )
    %goto exit;
  %end;
  
  %if %length( &sortby ) = 0 %then %do;
    %err_mput( macro=Finalize_data_set, msg=Sort by variables not specified (sortby=). )
    %goto exit;
  %end;
  
  %if not( %mparam_is_yes( &archive ) or %mparam_is_no( &archive ) ) %then %do;
    %err_mput( macro=Finalize_data_set, msg=Archive= must be specified as Y/N. (archive=%str(&archive)). )
    %goto exit;
  %end;
  
  %if %length( &creator_process ) = 0 %then %do;
    %err_mput( macro=Finalize_data_set, msg=Creator process not specified (creator_process=). )
    %goto exit;
  %end;
  
  %if %length( &revisions ) = 0 %then %do;
    %err_mput( macro=Finalize_data_set, msg=Revisions not specified (revisions=). )
    %goto exit;
  %end;
  
  %** Check for existance of input data set **;
  
  %if not( %Dataset_exists( &data ) ) %then %do;
    %err_mput( macro=Finalize_data_set, msg=Input data set %str(%upcase(&data)) does not exist. )
    %goto exit;
  %end;
  
  %** Finalize data set **;
  
  %if &_remote_batch_submit %then %do;
  
    %note_mput( macro=Finalize_data_set, msg=Remote batch submit. Data set will be finalized. )

    %if %Dataset_exists( &outlib..&out ) %then %do;
      %warn_mput( macro=Finalize_data_set, msg=Existing data set %str(%upcase(&outlib..&out)) will be replaced. )
    %end;
  
    ** Sort to final data set and label **;
    
    proc sort data=&data out=&outlib..&out (label=&label);
      by &sortby;
    run;
    
    ** Print file info **;
    
    %File_info(
      data=&outlib..&out,
      contents=&contents,
      printobs=&printobs,
      printchar=&printchar,
      printvars=&printvars,
      freqvars=&freqvars,
      stats=&stats
    )
  
    %** Archive data set **;
    
    %if %mparam_is_yes( &archive ) %then %do;
    
      %if %length( &archive_name ) = 0 %then %let archive_name = %scan( &_program, 1, . );

      %note_mput( macro=Finalize_data_set, msg=Final data set will be added to %str(%upcase(&archive_name)) archive. )

      %Archive_data_sets( data=&out, lib=&outlib, zip_pre=&archive_name, zip_suf=, overwrite=y, quiet=y )      

    %end;
    
    %if %mparam_is_yes( &register_metadata ) %then %do;
    
      ** Add to metadata **;
      
      %Dc_update_meta_file(
        ds_lib=&outlib,
        ds_name=&out,
        creator_process=&creator_process,
        restrictions=&restrictions,
        revisions=%str(&revisions)
      )
    
    %end;
    
  %end;
  %else %do;
  
    %note_mput( macro=Finalize_data_set, msg=Not remote batch submit. Data set will not be finalized. )

    %if %Dataset_exists( &outlib..&out ) %then %do;
      %warn_mput( macro=Finalize_data_set, msg=Existing data set %str(%upcase(&outlib..&out)) will be replaced on remote batch submit. )
    %end;

    ** Sort and label temporary data set **;
    
    proc sort data=&data (label=&label);
      by &sortby;
    run;
    
    %File_info(
      data=&data,
      contents=&contents,
      printobs=&printobs,
      printchar=&printchar,
      printvars=&printvars,
      freqvars=&freqvars,
      stats=&stats
    )
  
  %end;

  %exit:
  
  %note_mput( macro=Finalize_data_set, msg=Exiting macro. )

%mend Finalize_data_set;

/** End Macro Definition **/

