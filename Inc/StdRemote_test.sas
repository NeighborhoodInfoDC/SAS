/**************************************************************************
 Program:  StdRemote.sas
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Updated:  11/3/13
 Version:  SAS 9.4
 
 Description:  Standard header file for remote Windows environment.
 
**************************************************************************/

%global _dcdata_l_drive _dcdata_r_drive _dcdata_l_path _dcdata_r_path 
        _dcdata_path _dcdata_default_path _dcdata_working_path _dcdata_final_path
        _dcdata_census_api_key
        _remote_session _remote_batch_submit _final_batch_submit _userid;

%** Assign local/remote drives **;

%let _dcdata_l_drive = F:;
%let _dcdata_r_drive = F:;

%** Set values for folder locations **;

%let _dcdata_l_path = &_dcdata_l_drive\DCData\Libraries\&SYSUSERID;
%let _dcdata_r_path = &_dcdata_r_drive\DCData\Libraries\Final;
%let _dcdata_path = &_dcdata_r_path;
%let _dcdata_working_path = &_dcdata_l_path;
%let _dcdata_final_path = &_dcdata_r_path;

** Locations of SAS autocall macro libraries **;

filename uiautos  "&_dcdata_r_drive\DCData\Uiautos";
filename dcautos  "&_dcdata_r_drive\DCData\SAS\Macros";
options sasautos=(dcautos uiautos sasautos);

%** Set values for _remote_session, _final_batch_submit, _remote_batch_submit **;
%** _remote_batch_submit is deprecated in favor of _final_batch_submit, but kept for backward compatibility **;

%let _remote_session = 1;

%let _final_batch_submit = %mif_select( %sysfunc( find( &SYSPROCESSNAME, &_dcdata_r_path, i ) ) > 0, 1, 0 );
%let _remote_batch_submit = &_final_batch_submit;

%let _dcdata_default_path = %mif_select( &_final_batch_submit, &_dcdata_r_path, &_dcdata_l_path );

** Program name & library **;

%GetProgName( _program )
%GetProgLib( _library )
%GetProgDrive( _pdrive )

** Metadata library **;

libname _metadat "&_dcdata_r_path\Metadata\Data";

** System options **;

options compress=yes msglevel=i nocenter mprint nofmterr source2 minoperator mindelimiter=','
        mergenoby=warn formchar="|----|+|---+=|-/\<>*";

options ls=124 ps=48;    ** Landscape **;

%SAS_compatibility()

** Output title **;

title "&_library/&_program: Urban-Greater DC";

** Define General library for local session only **;

%DCData_lib( General, env=windows, macdef=dcautos uiautos sasautos )

%let _userid = %sysfunc( putc( %lowcase(&SYSUSERID), $longusr. ) );

** Load Census API key **;

%include "&_dcdata_r_drive\DCData\SAS\Inc\Census_api.key";
