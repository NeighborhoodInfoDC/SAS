/**************************************************************************
 Macro:    Create_all_summary_from_tracts
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/29/06
 Version:  SAS 9.2
 Environment:  Windows
 
 Description:  Create all summary level files from a tract level summary file.

 Modifications:
  08/27/06 PAT Added REVISIONS= parameter.
  09/26/06 PAT Added LIB= parameter.
  12/22/10 PAT Added MPRINT= parameter.
  07/14/12 PAT Removed casey_nbr2003 and casey_ta2003 from list of geos.
               Added Anc2012, Ward2012, and Psa2010.
               Added TRACT_YR= parameter for specifying source tract year.
               DISABLED ALL GEOS EXCEPT WARDS FOR TESTING.
  07/21/12 PAT Added tract-level summary for 2010 (if based on 2000 tracts)
               or for 2000 (if based on 2010).
  09/09/12 PAT Final production version for all geos.
  12/17/12 PAT Added summary for voting precincts (VoterPre2012).
**************************************************************************/

%macro Create_all_summary_from_tracts( 
  lib=,
  data_pre=,
  data_label=,
  count_vars=, 
  prop_vars=, 
  calc_vars=, 
  calc_vars_labels=,
  tract_yr=2000,
  register=,
  finalize=y,
  creator_process=,
  restrictions=,
  revisions=,
  mprint=n
);

  %local outlib;

  %if %mparam_is_yes( &finalize ) and not &_REMOTE_BATCH_SUBMIT %then %do; 
    %warn_mput( macro=Create_all_summary_from_tracts, msg=%str(Not a remote batch submit session. Finalize will be set to N.) )
    %let Finalize = N;
  %end;

  %if &register ~= and ( 
      ( %mparam_is_yes( &finalize ) and not %mparam_is_yes( &register ) ) or 
      ( %mparam_is_no( &finalize ) and not %mparam_is_no( &register ) ) ) %then %do;
    %warn_mput( macro=Create_all_summary_from_tracts, msg=Finalize= parameter overrides register=. Finalize=&Finalize )
  %end;
  
  %if not %mparam_is_yes( &finalize ) %then %let outlib = work;
  %else %let outlib = &lib;

  %Create_summary_from_tracts( geo=city, 
    lib=&lib, outlib=&outlib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=eor, 
    lib=&lib, outlib=&outlib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=ward2002, 
    lib=&lib, outlib=&outlib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=ward2012, 
    lib=&lib, outlib=&outlib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=zip, 
    lib=&lib, outlib=&outlib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=psa2004, 
    lib=&lib, outlib=&outlib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=psa2012, 
    lib=&lib, outlib=&outlib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=anc2002, 
    lib=&lib, outlib=&outlib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=anc2012, 
    lib=&lib, outlib=&outlib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=cluster_tr2000, 
    lib=&lib, outlib=&outlib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %Create_summary_from_tracts( geo=voterpre2012, 
    lib=&lib, outlib=&outlib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
    prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
    tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
    restrictions=&restrictions, revisions=&revisions, mprint=&mprint )

  %if &tract_yr = 2000 %then %do;
    %Create_summary_from_tracts( geo=geo2010, 
      lib=&lib, outlib=&outlib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
      prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
      tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
      restrictions=&restrictions, revisions=&revisions, mprint=&mprint )
  %end;
  %else %if &tract_yr = 2010 %then %do;
    %Create_summary_from_tracts( geo=geo2000, 
      lib=&lib, outlib=&outlib, data_pre=&data_pre, data_label=&data_label, count_vars=&count_vars,
      prop_vars=&prop_vars, calc_vars=&calc_vars, calc_vars_labels=&calc_vars_labels,
      tract_yr=&tract_yr, register=&finalize, creator_process=&creator_process,
      restrictions=&restrictions, revisions=&revisions, mprint=&mprint )
  %end;

%mend Create_all_summary_from_tracts;



