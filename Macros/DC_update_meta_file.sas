/************************************************************************
 Macro:    DC_update_meta_file
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  11/02/04
 Version:  SAS 9.2
 Environment:  Windows
 
 Description: Update file entry in metadata system.

 Modifications:
  12/30/04  Allow specification of desc_stats= parameter.
            Check that value of restrictions= is either None or 
            Confidential.
  05/06/05  If restrictions=Confidential, replace with formatted label 
            and link to restrictions web page.
  12/06/06  Added SUPPR5F as an excluded format.
            Changed MAX_FMT_VALS= to 50.
  04/03/07  Send email notification to PT + user.
  06/09/10  Changed email notification to @urban.org.
  11/30/10  Write _userid to LOG (for debugging).
  03/04/11  PAT Added declaration for local macro vars.
  11/09/13  PAT Revised for use with new SAS1 server setup.
                Disabled email notification of metadata updates 
                (not supported on SAS1).
  03/30/14  PAT Added creator= parameter to allow manual entry of
                user id. 
************************************************************************/

%macro DC_update_meta_file( 
         ds_lib= ,
         ds_name= ,
         creator_process= ,
         creator= ,
         revisions= ,
         format=SAS,
         desc_stats=n sum mean std min max,
         restrictions=None,
         quiet=N,
         debug=N
  );

  %local restrict_param ds_lib_r;
  
  %** Check whether running remote batch submit **;
  
  %if not &_remote_batch_submit %then %do;
       %warn_mput( macro=DC_update_meta_file, 
                   msg=%str(Not a remote batch submit session. Metadata will not be updated.) )
       %goto exit;
  %end; 

  %** Get name of remote library **;
  
  %let ds_lib_r = %ConvertLibname( &ds_lib, r ); 
  
  %if %upcase( &ds_lib ) ~= %upcase( &ds_lib_r ) %then %do;
    %Note_mput( macro=DC_update_meta_file, msg=Data set will be processed from remote library (%upcase(&ds_lib_r)). )
  %end;

  %** Check that Restrictions= is either None or Confidential **;
  %** If Confidential, replace with formatted label and link to restrictions page **;

  %let restrictions = %MCapitalize( &restrictions );

  %if &restrictions = None %then %do;
    %let restrict_param = &restrictions;
  %end;
  %else %if &restrictions = Confidential %then %do;
    %let restrict_param = <b><font color=""#FF0000"">Confidential</font></b>%nrstr(&nbsp;&nbsp;-&nbsp;&nbsp;)<a href=""restrictions_%lowcase(&ds_lib).html"">File restrictions</a>;
  %end;
  %else %do;
    %Err_mput( macro=DC_update_meta_file, msg=Value of Restrictions= must be either None or Confidential. )
    %goto exit;
  %end;

  %Note_mput( macro=DC_update_meta_file, msg=_userid=&_userid )

  %** Default creator is current user **;
  %if &creator = %then %let creator = &_userid;
  %else %let creator = %sysfunc( putc( %lowcase(&creator), $longusr. ) );
  
  %Update_metadata_file( 
         ds_lib=&ds_lib_r,
         ds_lib_display=&ds_lib,
         ds_name=&ds_name,
         creator=&creator,
         creator_process=&creator_process ,
         revisions=&revisions ,
         format=&format,
         max_fmt_vals=50,
         add_exclude_fmts="/SUPPR5F/",
         restrictions=&restrict_param,
         desc_stats=&desc_stats,
         meta_lib=_metadat,
         meta_pre=meta,
         /****update_notify=&update_notify,****/
         quiet=&quiet,
         debug=&debug
  )

  %exit:
  %Note_mput( macro=DC_update_meta_file, msg=Exiting macro. )

%mend DC_update_meta_file;

